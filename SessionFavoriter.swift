import Foundation
import UIKit
import UserNotifications
private let kSessionNotificationNotice = TimeInterval(5 * 60)
@available(iOS 10.0, *)
protocol SessionFavoriter {
  func toggleFavorite(session: Session)
}
@available(iOS 10.0, *)
extension SessionFavoriter where Self: UIViewController {
  func toggleFavorite(session: Session) {
    session.toggleFavorite()
    if session.isFavorite {
      scheduleNotificationIfNeeded(for: session)
    } else {
      cancelNotification(for: session)
    }
  }
  private func scheduleNotificationIfNeeded(for session: Session) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        switch settings.authorizationStatus {
        case .notDetermined:
          self.promptForNotification(for: session)
        case .authorized:
          self.scheduleLocalNotification(for: session)
        case .provisional:
          self.promptForNotification(for: session)
        case .denied:
          break
        }
      }
    }
  }
  private func promptForNotification(for session: Session) {
    let title = NSLocalizedString("FAVORITE_NOTIFICATION_ALERT_TITLE", comment: "")
    let message = NSLocalizedString("FAVORITE_NOTIFICATION_ALERT_MESSAGE", comment: "")
    let cancel = NSLocalizedString("FAVORITE_NOTIFICATION_ALERT_CANCEL", comment: "")
    let OK = NSLocalizedString("FAVORITE_NOTIFICATION_ALERT_OK", comment: "")
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: OK, style: .default) { _ in
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
        if !success {
          return
        }
        DispatchQueue.main.async {
          self.scheduleLocalNotification(for: session)
        }
      }
    })
    present(alert, animated: true, completion: nil)
  }
  private func scheduleLocalNotification(for session: Session) {
    let content = UNMutableNotificationContent()
    content.title = NSLocalizedString("NOTIFICATION_TITLE", comment: "")
    content.body = String(format: NSLocalizedString("NOTIFICATION_SUBTITLE_FORMAT", comment: ""),
                          session.title, session.location)
    print("时间戳：",session.date.start.timeIntervalSinceNow)
    let timeInterval = session.date.start.timeIntervalSinceNow - kSessionNotificationNotice
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    let request = UNNotificationRequest(identifier: session.id, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  private func cancelNotification(for session: Session) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [session.id])
  }
}
