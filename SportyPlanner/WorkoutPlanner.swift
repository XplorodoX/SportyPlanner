import Foundation

/// Platzhalter-Planer, der ein lokales LLM zur Erstellung eines Zeitplans verwenden würde.
struct WorkoutPlanner {
    /// Generiert einen einfachen Plan für bevorstehende Workouts.
    func generatePlan() -> [Workout] {
        // In einer realen Implementierung würde hier ein lokales LLM aufgerufen, um den Plan zu generieren.
        
        var workouts: [Workout] = []
        let today = Date()
        
        // Workout 1: Brust & Trizeps (z.B. Montag)
        let chestWorkout = Workout(name: "Brust & Trizeps", date: self.dayOfWeek(for: today, weekday: .monday), exercises: [
            Exercise(name: "Bankdrücken", sets: 4, reps: 8),
            Exercise(name: "Schrägbankdrücken", sets: 3, reps: 10),
            Exercise(name: "Dips", sets: 3, reps: 12)
        ])
        workouts.append(chestWorkout)

        // Workout 2: Rücken & Bizeps (z.B. Mittwoch)
        let backWorkout = Workout(name: "Rücken & Bizeps", date: self.dayOfWeek(for: today, weekday: .wednesday), exercises: [
            Exercise(name: "Klimmzüge", sets: 4, reps: 8),
            Exercise(name: "Rudern", sets: 3, reps: 10),
            Exercise(name: "Bizepscurls", sets: 3, reps: 12)
        ])
        workouts.append(backWorkout)
        
        // Workout 3: Beine & Schultern (z.B. Freitag)
        let legWorkout = Workout(name: "Beine & Schultern", date: self.dayOfWeek(for: today, weekday: .friday), exercises: [
            Exercise(name: "Kniebeugen", sets: 4, reps: 8),
            Exercise(name: "Beinpresse", sets: 3, reps: 10),
            Exercise(name: "Schulterdrücken", sets: 4, reps: 10)
        ])
        workouts.append(legWorkout)

        return workouts
    }

    /// Hilfsfunktion, um das Datum für einen bestimmten Wochentag in der aktuellen Woche zu erhalten.
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
