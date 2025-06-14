import SwiftUI
import SwiftData

struct WeekCalendarView: View {
    @Query(sort: \Workout.date) private var workouts: [Workout]
    @Query(sort: \CardioSession.date) private var cardioSessions: [CardioSession]
    
    @State private var selectedDate: Date = Date()
    @State private var weekOffset: Int = 0
    @State private var showingAddSheet = false
    @State private var activityTypeToAdd: ActivityType?

    enum ActivityType { case workout, cardio }
    
    private var currentWeek: [Date] {
        guard let referenceDate = Calendar.current.date(byAdding: .weekOfYear, value: weekOffset, to: Date()) else { return [] }
        return Calendar.current.datesOfWeek(containing: referenceDate)
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Wochen-Navigation
                HStack {
                    Button(action: { withAnimation { weekOffset -= 1 } }) {
                        Image(systemName: "chevron.left.circle.fill")
                    }
                    Spacer()
                    Text(weekHeader)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: { withAnimation { weekOffset += 1 } }) {
                        Image(systemName: "chevron.right.circle.fill")
                    }
                }
                .padding()
                .font(.title2)

                // Kalendertage
                HStack(spacing: 4) {
                    ForEach(currentWeek, id: \.self) { date in
                        dayCell(for: date)
                    }
                }
                .padding(.horizontal)

                // Aktivitätenliste
                List {
                    Section("Aktivitäten am \(selectedDate, format: .dateTime.day().month(.wide))") {
                        let dailyWorkouts = workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                        let dailyCardio = cardioSessions.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }

                        if dailyWorkouts.isEmpty && dailyCardio.isEmpty {
                            ContentUnavailableView("Keine Pläne", systemImage: "calendar.badge.exclamationmark")
                        } else {
                            ForEach(dailyWorkouts) { workout in
                                Label("Workout: \(workout.name)", systemImage: "dumbbell.fill")
                            }
                            ForEach(dailyCardio) { session in
                                Label("Cardio: \(session.type.rawValue.capitalized)", systemImage: "figure.run")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Wochenplan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Neues Workout", systemImage: "dumbbell.fill") {
                            activityTypeToAdd = .workout
                            showingAddSheet = true
                        }
                        Button("Neue Cardio-Einheit", systemImage: "figure.run") {
                            activityTypeToAdd = .cardio
                            showingAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                if activityTypeToAdd == .workout {
                    AddWorkoutView()
                } else if activityTypeToAdd == .cardio {
                    AddCardioView()
                }
            }
        }
    }
    
    private var weekHeader: String {
        let firstDay = currentWeek.first ?? Date()
        let lastDay = currentWeek.last ?? Date()
        return "\(firstDay.formatted(.dateTime.month().day())) - \(lastDay.formatted(.dateTime.month().day()))"
    }

    @ViewBuilder
    private func dayCell(for date: Date) -> some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        VStack {
            Text(date, format: .dateTime.weekday(.short))
                .font(.caption)
                .foregroundColor(isSelected ? .white : .secondary)
            Text(date, format: .dateTime.day())
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: 35, height: 35)
                .background(
                    ZStack {
                        if isSelected {
                            Circle().fill(Color.accentColor)
                        } else if hasActivity(for: date) {
                            Circle().stroke(Color.accentColor.opacity(0.5), lineWidth: 2)
                        }
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            withAnimation(.spring) {
                selectedDate = date
            }
        }
    }

    private func hasActivity(for date: Date) -> Bool {
        let calendar = Calendar.current
        return workouts.contains { calendar.isDate($0.date, inSameDayAs: date) } ||
               cardioSessions.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

extension Calendar {
    func datesOfWeek(containing date: Date) -> [Date] {
        guard let weekInterval = self.dateInterval(of: .weekOfYear, for: date) else { return [] }
        return (0..<7).compactMap { day in
            self.date(byAdding: .day, value: day, to: weekInterval.start)
        }
    }
}
