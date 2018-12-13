import UIKit
final class MapPresentationSegue: UIStoryboardSegue {
  override func perform() {
    let idiom = source.traitCollection.userInterfaceIdiom
    if idiom == .pad {
      destination.modalPresentationStyle = .pageSheet
    }
    super.perform()
  }
}
