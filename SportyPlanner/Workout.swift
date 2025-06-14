import Foundation
import SwiftData

@Model
final class Workout {
    var name: String
    var date: Date
    var exercises: [Exercise]

    init(name: String, date: Date, exercises: [Exercise] = []) {
        self.name = name
        self.date = date
        self.exercises = exercises
    }
}
