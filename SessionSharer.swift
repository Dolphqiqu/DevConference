import UIKit
import Social
@available(iOS 10.0, *)
protocol SessionSharer {
    func shareSession(_ session: Session)
}
@available(iOS 10.0, *)
extension SessionSharer where Self: UIViewController {
  func shareSession(_ session: Session) {
    let title = NSLocalizedString("SHARE_ACTION_SHEET_TITLE", comment: "")
    let message = NSLocalizedString("SHARE_ACTION_SHEET_MESSAGE", comment: "")
    let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    let takePictureTitle = NSLocalizedString("SHARE_ACTION_SHEET_TAKE_PICTURE", comment: "")
    let selectPictureTitle = NSLocalizedString("SHARE_ACTION_SHEET_SELECT_PICTURE", comment: "")
    let noPictureTitle = NSLocalizedString("SHARE_ACTION_SHEET_NO_PICTURE", comment: "")
    let cancelTitle = NSLocalizedString("SHARE_ACTION_SHEET_CANCEL", comment: "")
    actionSheet.addAction(UIAlertAction(title: takePictureTitle, style: .default, handler: takePicture))
    actionSheet.addAction(UIAlertAction(title: selectPictureTitle, style: .default, handler: selectPicture))
    actionSheet.addAction(UIAlertAction(title: noPictureTitle, style: .destructive) { [unowned self] action in
      self.showShareSheet(text: self.shareText(for: session), image: nil)
    })
    actionSheet.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: dismiss))
    actionSheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(actionSheet, animated: true, completion: nil)
  }
  private func shareText(for session: Session) -> String? {
    guard let twitterHandles = session.speakers?.map({ "@" + $0.twitterHandle }) else {
      return nil
    }
    let separator = NSLocalizedString("SHARE_SESSION_SPEAKER_CONCATENATION", comment: "")
    let handles = twitterHandles.joined(separator: separator)
    return String(format: NSLocalizedString("SHARE_SESSION_BODY", comment: ""), session.title, handles)
  }
  private func dismiss(action: UIAlertAction) {
    dismiss(animated: true, completion: nil)
  }
  private func takePicture(action: UIAlertAction) {
    showImagePicker(forSourceType: .camera)
  }
  private func selectPicture(action: UIAlertAction) {
    showImagePicker(forSourceType: .photoLibrary)
  }
  private func showImagePicker(forSourceType sourceType: UIImagePickerControllerSourceType) {
    let picker = ImagePicker()
    picker.sourceType = sourceType
    if sourceType == .camera {
      picker.cameraFlashMode = .off
    }
    picker.present(from: self) { [weak self] image in
      self?.showShareSheet(image: image)
    }
  }
  private func showShareSheet(text: String? = nil, image: UIImage? = nil) {
    let items = [text as Any, image as Any].flatMap { $0 }
    let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    activityController.excludedActivityTypes = [.addToReadingList, .assignToContact,
                                                    .openInIBooks, .print]
    present(activityController, animated: true, completion: nil)
  }
}
private typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
private final class ImagePicker: UIImagePickerController, ImagePickerDelegate {
  private var completion: ((UIImage?) -> Void)?
  func present(from presentingController: UIViewController, completion: @escaping (UIImage?) -> Void) {
    self.completion = completion
    delegate = self
    presentingController.present(self, animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any])
  {
    dismiss(animated: true) { [weak self] in
      let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
      let originalImage = info [UIImagePickerControllerOriginalImage] as? UIImage
      self?.completion?(editedImage ?? originalImage)
    }
  }
}
