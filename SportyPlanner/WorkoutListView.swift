import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .forward) private var workouts: [Workout]

    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                            Text(workout.date, format: .dateTime.day().month().year())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
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
