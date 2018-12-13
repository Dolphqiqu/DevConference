import UIKit
final class ConferenceMapViewController: UIViewController {
  @IBOutlet private var scrollView: UIScrollView!
  @IBOutlet private var doneButton: UIButton!
  private let tapGesture = UITapGestureRecognizer()
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doneButton.isHidden = modalPresentationStyle == .pageSheet
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scrollView.flashScrollIndicators()
    addTapGesture()
  }
  private func addTapGesture() {
    tapGesture.addTarget(self, action: #selector(handleTap(sender:)))
    tapGesture.delegate = self
    view.window?.addGestureRecognizer(tapGesture)
  }
  @objc
  private func handleTap(sender: UITapGestureRecognizer) {
    if !view.bounds.contains(sender.location(in: view)) {
      dismiss()
    }
  }
  @IBAction private func dismiss() {
    tapGesture.view?.removeGestureRecognizer(tapGesture)
    dismiss(animated: true, completion: nil)
  }
}
extension ConferenceMapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
  {
    return true
  }
}
