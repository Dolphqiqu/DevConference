import UIKit
private let kConferenceCell = "ConferenceCell"
@available(iOS 10.0, *)
final class ConferenceSelectionTableViewController: UITableViewController {
  var conferences: [Conference] = []
  var selectedConference: Conference?
  var completion: ((Conference) -> Void)?
  override func viewWillAppear(_ animated: Bool) {
    if let row = conferences.index(where: { $0 == selectedConference }) {
      let indexPath = IndexPath(row: row, section: 0)
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    tableView.layoutIfNeeded()
    preferredContentSize = tableView.contentSize
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conferences.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kConferenceCell, for: indexPath)
    cell.textLabel?.text = conferences[indexPath.row].name
    cell.detailTextLabel?.text = conferences[indexPath.row].formattedDate
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    completion?(conferences[indexPath.row])
    dismiss(animated: true, completion: nil)
  }
}
