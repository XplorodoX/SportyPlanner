import Foundation
import SwiftData
import CoreLocation

/// Lightweight representation of a location that can be stored with SwiftData.
struct TrackPoint: Codable, Hashable {
    var latitude: Double
    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

@Model
final class CardioSession {
    enum ActivityType: String, Codable {
        case running
        case cycling
    }

    var type: ActivityType
    var date: Date
    var duration: TimeInterval
    var locations: [TrackPoint]

    init(type: ActivityType, date: Date, duration: TimeInterval, locations: [TrackPoint]) {
        self.type = type
        self.date = date
        self.duration = duration
        self.locations = locations
    }
}
