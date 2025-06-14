import Foundation
import CoreLocation

/// Platzhalter-Planer, der ein lokales LLM zur Erstellung eines Zeitplans verwenden würde.
struct WorkoutPlanner {
    /// Generiert einen einfachen Plan für bevorstehende Workouts.
    func generatePlan() -> [Workout] {
        var workouts: [Workout] = []
        let today = Date()
        
        let chestWorkout = Workout(name: "Brust & Trizeps", date: self.dayOfWeek(for: today, weekday: .monday), exercises: [
            Exercise(name: "Bankdrücken", sets: 4, reps: 8),
            Exercise(name: "Schrägbankdrücken", sets: 3, reps: 10),
            Exercise(name: "Dips", sets: 3, reps: 12)
        ])
        workouts.append(chestWorkout)

        let backWorkout = Workout(name: "Rücken & Bizeps", date: self.dayOfWeek(for: today, weekday: .wednesday), exercises: [
            Exercise(name: "Klimmzüge", sets: 4, reps: 8),
            Exercise(name: "Rudern", sets: 3, reps: 10),
            Exercise(name: "Bizepscurls", sets: 3, reps: 12)
        ])
        workouts.append(backWorkout)
        
        let legWorkout = Workout(name: "Beine & Schultern", date: self.dayOfWeek(for: today, weekday: .friday), exercises: [
            Exercise(name: "Kniebeugen", sets: 4, reps: 8),
            Exercise(name: "Beinpresse", sets: 3, reps: 10),
            Exercise(name: "Schulterdrücken", sets: 4, reps: 10)
        ])
        workouts.append(legWorkout)

        return workouts
    }

    /// Generiert eine Beispiel-Cardio-Einheit mit einer Route für die Kartenansicht.
    func generateSampleCardio() -> CardioSession {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let locations: [TrackPoint] = [
            .init(latitude: 49.5932, longitude: 11.0074), // Start: Erlangen
            .init(latitude: 49.5955, longitude: 11.0085),
            .init(latitude: 49.5988, longitude: 11.0062),
            .init(latitude: 49.6010, longitude: 11.0100),
            .init(latitude: 49.5995, longitude: 11.0155)  // Ende
        ]
        
        return CardioSession(type: .running, date: yesterday, duration: 1800, locations: locations) // 30 Minuten
    }

    private func dayOfWeek(for date: Date, weekday: Weekday) -> Date {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return date }
        
        let dayComponent = DateComponents(weekday: weekday.rawValue)
        return calendar.nextDate(after: weekInterval.start, matching: dayComponent, matchingPolicy: .nextTime, direction: .forward) ?? date
    }
    
    enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
}
