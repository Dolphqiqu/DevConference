import Foundation
import UIKit
struct Speaker: Codable {
  let name: String
  let bio: String
  let twitterHandle: String
  private let photoName: String
  var photo: UIImage? { return UIImage(named: photoName) }
  enum CodingKeys: String, CodingKey {
    case name
    case bio
    case twitterHandle = "twitter_handle"
    case photoName = "photo_name"
  }
}
