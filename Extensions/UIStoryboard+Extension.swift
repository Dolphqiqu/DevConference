import UIKit
extension UIStoryboard {
  func instantiateViewController<T: UIViewController>() -> T {
    let identifier = String(describing: T.self).components(separatedBy: ".").last!
    guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("View controller for \(identifier) not found")
    }
    return viewController
  }
}
