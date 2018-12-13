import Foundation
import UIKit
import WatchKit
private var imageCache: [URL: UIImage] = [:]
#if os(iOS)
extension UIImageView {
  func setImage(at url: URL) {
    if let image = imageCache[url] {
      return self.image = image
    }
    let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          imageCache[url] = image
          self.image = image
        }
      }
    }
    dataTask.resume()
  }
}
#elseif os(watchOS)
extension WKInterfaceImage {
  func setImage(at url: URL, completion: ((Bool) -> Void)? = nil) {
    if let image = imageCache[url] {
      completion?(true)
      return self.setImage(image)
    }
    let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          imageCache[url] = image
          self.setImage(image)
          completion?(true)
        }
      } else {
        completion?(false)
      }
    }
    dataTask.resume()
  }
}
#endif
