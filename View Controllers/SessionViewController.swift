import UIKit
@available(iOS 10.0, *)
final class SessionViewController: UIViewController, SessionSharer, SessionFavoriter {
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var locationButton: UIButton!
  @IBOutlet private var timeLabel: UILabel!
  @IBOutlet private var pageControl: UIPageControl!
  @IBOutlet private var speakerScrollView: UIScrollView!
  @IBOutlet private var favoriteBarButtonItem: UIBarButtonItem!
  @IBOutlet private var rwConnectImage: UIImageView!
  private var speakerViews: [SpeakerView] = []
  var session: Session! {
    didSet { updateForCurrentSession() }
  }
  override var previewActionItems: [UIPreviewActionItem] {
    let titleKey = session.isFavorite ? "DELETE_FAVORITE" : "ADD_FAVORITE"
    let title = NSLocalizedString(titleKey, comment: "")
    let style: UIPreviewActionStyle = session.isFavorite ? .destructive : .default
    return [UIPreviewAction(title: title, style: style) { [weak self] _, _ in self?.toggleFavorite() }]
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    updateForCurrentSession()
    let image = UIImage(named: "rwdevcon-bg")
    navigationController?.navigationBar.setBackgroundImage(image, for: .default)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setToolbarHidden(true, animated: true)
  }
  private func updateForCurrentSession() {
    guard let session = session else {
      return
    }
    titleLabel?.text = session.title
    descriptionLabel?.text = session.description
    locationButton?.setTitle(session.location, for: .normal)
    timeLabel?.text = session.dayAndTime
    rwConnectImage?.isHidden = session.type != .rwconnect
    updateFavoriteBarButtonItem()
    updateSpeakers()
  }
  private func updateSpeakers() {
    guard let speakerScrollView = speakerScrollView else {
      return
    }
    speakerViews.forEach { $0.removeFromSuperview() }
    speakerViews = []
    session.speakers?.forEach(add)
    pageControl.numberOfPages = speakerViews.count
    speakerViews.last?.trailingAnchor.constraint(equalTo: speakerScrollView.trailingAnchor).isActive = true
    let heights = speakerViews.map { $0.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height }
    let effectiveHeight = heights.max() ?? 0
    speakerScrollView.heightAnchor.constraint(equalToConstant: effectiveHeight).isActive = true
  }
  private func add(speaker: Speaker) {
    let speakerView = SpeakerView(speaker: speaker)
    speakerScrollView.addSubview(speakerView)
    let aligningAnchor = speakerViews.last?.trailingAnchor ?? speakerScrollView.leadingAnchor
    NSLayoutConstraint.activate([
      speakerView.topAnchor.constraint(equalTo: speakerScrollView.topAnchor),
      speakerView.leadingAnchor.constraint(equalTo: aligningAnchor),
      speakerView.widthAnchor.constraint(equalTo: speakerScrollView.widthAnchor),
    ])
    speakerViews.append(speakerView)
  }
  private func updateFavoriteBarButtonItem() {
    let key = session.isFavorite ? "UNMARK_AS_FAVORITE" : "MARK_AS_FAVORITE"
    favoriteBarButtonItem.title = NSLocalizedString(key, comment: "")
  }
  @IBAction private func toggleFavorite() {
    toggleFavorite(session: session)
    updateFavoriteBarButtonItem()
  }
  @IBAction private func shareSession() {
    shareSession(session)
  }
}
@available(iOS 10.0, *)
extension SessionViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == speakerScrollView {
      pageControl.currentPage = Int(ceil(scrollView.contentOffset.x / scrollView.bounds.width))
    }
  }
}
