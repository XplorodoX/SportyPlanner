import Foundation
import SwiftData
import CoreLocation

@Model
final class CardioSession {
    enum ActivityType: String, Codable {
        case running
        case cycling
    }

    var type: ActivityType
    var date: Date
    var duration: TimeInterval
    var locations: [CLLocation]

    init(type: ActivityType, date: Date, duration: TimeInterval, locations: [CLLocation] = []) {
        self.type = type
        self.date = date
        self.duration = duration
        self.locations = locations
    }
}
