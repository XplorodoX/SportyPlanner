import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .forward) private var workouts: [Workout]
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        HStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(workout.date, format: .dateTime.weekday(.wide))
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                                    .fontWeight(.bold)
                                Text(workout.date, format: .dateTime.day())
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 60)
                            
                            VStack(alignment: .leading) {
                                Text(workout.name)
                                    .font(.headline)
                                Text("\(workout.exercises.count) Übungen")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .listStyle(.plain)
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddWorkoutView()
            }
        }
    }

    private func deleteWorkouts(at offsets: IndexSet) {
        for index in offsets {
            let workoutToDelete = workouts[index]
            modelContext.delete(workoutToDelete)
        }
    }
}
