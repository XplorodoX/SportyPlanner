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
            VStack(spacing: 0) {
                // Wochen-Navigation und Kalendertage
                VStack {
                    HStack {
                        Button(action: { withAnimation(.easeInOut) { weekOffset -= 1 } }) {
                            Image(systemName: "chevron.left.circle.fill")
                        }
                        Spacer()
                        Text(weekHeader)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .transition(.opacity.combined(with: .scale))
                        Spacer()
                        Button(action: { withAnimation(.easeInOut) { weekOffset += 1 } }) {
                            Image(systemName: "chevron.right.circle.fill")
                        }
                    }
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                    .padding([.horizontal, .top])

                    HStack(spacing: 4) {
                        ForEach(currentWeek, id: \.self) { date in
                            dayCell(for: date)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .background(.bar)

                // Aktivitätenliste
                List {
                    Section {
                        let dailyWorkouts = workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                        let dailyCardio = cardioSessions.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }

                        if dailyWorkouts.isEmpty && dailyCardio.isEmpty {
                            ContentUnavailableView {
                                Label("Keine Pläne für heute", systemImage: "calendar.badge.exclamationmark")
                            } description: {
                                Text("Füge ein neues Workout oder eine Cardio-Einheit hinzu.")
                            }
                        } else {
                            ForEach(dailyWorkouts) { workout in
                                Label {
                                    Text(workout.name)
                                        .fontWeight(.medium)
                                } icon: {
                                    Image(systemName: "dumbbell.fill")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            ForEach(dailyCardio) { session in
                                Label {
                                    Text(session.type.rawValue.capitalized)
                                        .fontWeight(.medium)
                                } icon: {
                                    Image(systemName: "figure.run")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    } header: {
                        Text("Aktivitäten am \(selectedDate.formatted(.dateTime.day().month(.wide)))")
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
        if Calendar.current.isDate(firstDay, equalTo: lastDay, toGranularity: .month) {
             return "\(firstDay.formatted(.dateTime.month(.wide).year()))"
        }
        return "\(firstDay.formatted(.dateTime.month().day())) – \(lastDay.formatted(.dateTime.month().day()))"
    }

    @ViewBuilder
    private func dayCell(for date: Date) -> some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        let activityExists = hasActivity(for: date)
        
        VStack(spacing: 8) {
            Text(date.formatted(.dateTime.weekday(.short)))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? Color.primary.opacity(0.9) : Color.secondary)
            
            Text(date.formatted(.dateTime.day()))
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: 40, height: 40)
                .background {
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor.gradient)
                            .shadow(radius: 3)
                    } else if activityExists {
                        Circle()
                            .fill(.gray.opacity(0.2))
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.snappy) {
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
