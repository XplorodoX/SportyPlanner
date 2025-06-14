import SwiftUI
import SwiftData

struct WeekCalendarView: View {
    @Query(sort: \Workout.date) private var workouts: [Workout]
    @Query(sort: \CardioSession.date) private var cardioSessions: [CardioSession]
    
    private var weekDates: [Date] {
        // Stellt sicher, dass die Woche am Montag beginnt
        let calendar = Calendar(identifier: .iso8601)
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return [] }
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: weekInterval.start)
        }
    }

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(weekDates, id: \.self) { date in
                    VStack {
                        Text(date, format: .dateTime.weekday(.narrow))
                            .font(.caption)
                        Text(date, format: .dateTime.day())
                            .fontWeight(Calendar.current.isDateInToday(date) ? .bold : .regular)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(hasActivity(for: date) ? Color.cyan.opacity(0.3) : Color.clear)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Calendar.current.isDateInToday(date) ? Color.accentColor.opacity(0.2) : Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            List {
                Section("Geplante Aktivitäten") {
                    ForEach(workouts.filter { $0.date >= Date() }) { workout in
                        Text("Workout: \(workout.name) - \(workout.date, format: .dateTime.weekday(.wide))")
                    }
                    ForEach(cardioSessions.filter { $0.date >= Date() }) { session in
                        Text("Cardio: \(session.type.rawValue.capitalized) - \(session.date, format: .dateTime.weekday(.wide))")
                    }
                }
            }
        }
        .navigationTitle("Wochenplan")
    }

    private func hasActivity(for date: Date) -> Bool {
        let calendar = Calendar.current
        let hasWorkout = workouts.contains { calendar.isDate($0.date, inSameDayAs: date) }
        let hasCardio = cardioSessions.contains { calendar.isDate($0.date, inSameDayAs: date) }
        return hasWorkout || hasCardio
    }
}

// Die Extension für Calendar ist nicht mehr nötig, da der Code oben integriert wurde.
// Behalten Sie sie bei, wenn Sie sie an anderer Stelle verwenden.
extension Calendar {
    func datesOfWeek(containing date: Date) -> [Date] {
        guard let weekInterval = dateInterval(of: .weekOfYear, for: date) else { return [] }
        return (0..<7).compactMap { day in
            self.date(byAdding: .day, value: day, to: weekInterval.start)
        }
    }
}

#Preview {
    WeekCalendarView()
        .modelContainer(for: [Workout.self, CardioSession.self], inMemory: true)
}
