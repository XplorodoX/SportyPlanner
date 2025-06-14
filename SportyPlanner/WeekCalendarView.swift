//
//  WeekCalendarView.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 14.06.25.
//

import SwiftUI
import SwiftData

struct WeekCalendarView: View {
    @Query(sort: \Workout.date) private var workouts: [Workout]
    @Query(sort: \CardioSession.date) private var cardioSessions: [CardioSession]
    
    @State private var selectedDate: Date = Date()
    @State private var weekOffset: Int = 0

    private var currentWeek: [Date] {
        let calendar = Calendar(identifier: .iso8601)
        guard let referenceDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: Date()) else { return [] }
        return calendar.datesOfWeek(containing: referenceDate)
    }

    var body: some View {
        VStack {
            // Wochen-Navigation
            HStack {
                Button(action: { weekOffset -= 1 }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentWeek.first?.formatted(.dateTime.month().year()) ?? "")
                    .font(.headline)
                Spacer()
                Button(action: { weekOffset += 1 }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            // Kalendertage
            HStack(spacing: 4) {
                ForEach(currentWeek, id: \.self) { date in
                    VStack {
                        Text(date, format: .dateTime.weekday(.narrow))
                            .font(.caption)
                        Text(date, format: .dateTime.day())
                            .fontWeight(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                            .padding(8)
                            .background(
                                ZStack {
                                    if Calendar.current.isDate(date, inSameDayAs: selectedDate) {
                                        Circle().fill(Color.accentColor.opacity(0.3))
                                    }
                                    if hasActivity(for: date) {
                                        Circle().stroke(Color.cyan, lineWidth: 2)
                                    }
                                }
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture { selectedDate = date }
                }
            }
            .padding(.horizontal)

            // Aktivitäten für den ausgewählten Tag
            List {
                Section("Aktivitäten am \(selectedDate, format: .dateTime.day().month())") {
                    let dailyWorkouts = workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                    let dailyCardio = cardioSessions.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }

                    if dailyWorkouts.isEmpty && dailyCardio.isEmpty {
                        Text("Keine Aktivitäten für diesen Tag geplant.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(dailyWorkouts) { workout in
                            HStack {
                                Image(systemName: "dumbbell.fill")
                                    .foregroundColor(.cyan)
                                Text("Workout: \(workout.name)")
                            }
                        }
                        ForEach(dailyCardio) { session in
                            HStack {
                                Image(systemName: session.type == .running ? "figure.run" : "bicycle")
                                    .foregroundColor(.cyan)
                                Text("Cardio: \(session.type.rawValue.capitalized)")
                            }
                        }
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

extension Calendar {
    func datesOfWeek(containing date: Date) -> [Date] {
        let calendar = Calendar(identifier: .iso8601)
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: weekInterval.start)
        }
    }
}

#Preview {
    WeekCalendarView()
        .modelContainer(for: [Workout.self, CardioSession.self], inMemory: true)
}
