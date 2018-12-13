import Foundation
@available(iOS 10.0, *)
struct Conference: Codable {
  let id: String
  let name: String
  let date: DateInterval
  let sessions: [[Session]]
  init(from decoder: Decoder) throws {
    let codingContainer = try decoder.container(keyedBy: CodingKeys.self)
    id = try codingContainer.decode(String.self, forKey: .id)
    name = try codingContainer.decode(String.self, forKey: .name)
    date = try codingContainer.decode(DateInterval.self, forKey: .date)
    let sessions = try codingContainer.decode([Session].self, forKey: .sessions)
    let groups = Array(Dictionary(grouping: sessions, by: { $0.dayAndTime }).keys)
    var grouped: [[Session]] = []
    for group in groups {
      grouped.append(sessions.filter { $0.dayAndTime == group }.sorted { $0.date < $1.date })
    }
    self.sessions = grouped.sorted { $0.first!.date < $1.first!.date }
  }
  var currentSessions: [Session] {
    return sessions.flatMap { $0 }.filter { $0.date.contains(Date()) }
  }
  var upcomingSessions: [Session] {
    for group in sessions where group.first!.date.start > Date() {
      return group
    }
    return []
  }
  var favoriteSessions: [[Session]] {
    let favoritesGrouped = sessions.map {
      $0.filter { $0.isFavorite }
    }
    return favoritesGrouped.filter { !$0.isEmpty }
  }
  var timeUntilStart: String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.day, .hour]
    formatter.unitsStyle = .full
    formatter.maximumUnitCount = 1
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "EDT")!
    formatter.calendar = calendar
    return formatter.string(from: date.start.timeIntervalSince(Date()))
  }
  var formattedDate: String {
    let formatter = DateIntervalFormatter()
    formatter.dateTemplate = "MMMd"
    formatter.timeZone = TimeZone(abbreviation: "EDT")!
    return formatter.string(from: date) ?? ""
  }
  func session(forID id: String) -> Session? {
    return currentSessions.first { $0.id == id }
  }
}
@available(iOS 10.0, *)
extension Conference: Equatable {
  static func == (lhs: Conference, rhs: Conference) -> Bool {
    return lhs.name == rhs.name
  }
}
