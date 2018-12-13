import Foundation
import UIKit
enum SessionType: String, Codable {
  case keynote
  case talk
  case workshop
  case rwconnect
  case inspiration
  var color: UIColor {
    switch self {
    case .keynote:
      return UIColor(red: 58/255, green: 46/255, blue: 57/255, alpha: 1)
    case .talk:
      return UIColor(red: 195/255, green: 172/255, blue: 206/255, alpha: 1)
    case .workshop:
      return UIColor(red: 56/255, green: 111/255, blue: 164/255, alpha: 1)
    case .rwconnect:
      return .white
    case .inspiration:
      return UIColor(red: 97/255, green: 155/255, blue: 138/255, alpha: 1)
    }
  }
}
@available(iOS 10.0, *)
struct Session: Codable {
  let id: String
  let title: String
  let description: String
  let type: SessionType
  let location: String
  let date: DateInterval
  let speakers: [Speaker]?
}
@available(iOS 10.0, *)
extension Session: Equatable {
  static func == (lhs: Session, rhs: Session) -> Bool {
    return lhs.id == rhs.id
  }
}
@available(iOS 10.0, *)
extension Session: Hashable {
  var hashValue: Int { return id.hashValue }
}
@available(iOS 10.0, *)
extension Session {
  var day: String {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE")
    formatter.timeZone = TimeZone(abbreviation: "EDT")
    return formatter.string(from: date.start)
  }
  var time: String {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("hh:mm j")
    formatter.timeZone = TimeZone(abbreviation: "EDT")
    return formatter.string(from: date.start)
  }
  var dayAndTime: String {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE hh:mm j")
    formatter.timeZone = TimeZone(abbreviation: "EDT")
    return formatter.string(from: date.start)
  }
}
