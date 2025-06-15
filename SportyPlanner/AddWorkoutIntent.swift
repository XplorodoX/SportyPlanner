import AppIntents
import SwiftData

/// Maksud untuk membuat latihan baru sehingga dapat dipicu dari Pintasan atau Siri.
struct AddWorkoutIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Workout"
    static var description = IntentDescription("Creates a new workout in SportyPlanner with a list of exercises.")

    @Parameter(title: "Name")
    var workoutName: String

    @Parameter(title: "Date")
    var date: Date
    
    // -- PERUBAHAN --
    // Parameter sekarang menerima daftar entitas latihan.
    @Parameter(title: "Exercises")
    var exercises: [ExerciseEntity]

    // Ringkasan parameter yang lebih bersih dan lebih dinamis.
    static var parameterSummary: some ParameterSummary {
        Summary("Create Workout \(\.$workoutName) on \(\.$date)") {
            \.$exercises
        }
    }

    @MainActor // Pastikan eksekusi terjadi pada utas utama untuk SwiftData
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let container = PersistenceController.shared.container
        let context = ModelContext(container)

        // Konversi ExerciseEntity menjadi model Exercise SwiftData
        let workoutExercises = exercises.map { exerciseEntity in
            Exercise(name: exerciseEntity.name, sets: exerciseEntity.sets, reps: exerciseEntity.reps)
        }
        
        // Pastikan kita memiliki setidaknya satu latihan
        guard !workoutExercises.isEmpty else {
            // Memberikan kesalahan yang akan dilihat pengguna di Pintasan jika tidak ada latihan yang ditambahkan.
            throw $exercises.needsValueError("Please add at least one exercise to the workout.")
        }

        let workout = Workout(name: workoutName, date: date, exercises: workoutExercises)
        context.insert(workout)
        
        // Simpan ke HealthKit seperti sebelumnya
        HealthKitManager.shared.saveWorkout(workout)
        
        // -- PERUBAHAN --
        // Memberikan hasil yang lebih kaya dengan cuplikan UI.
        let exerciseSummary = workoutExercises.map { "\($0.name) (\($0.sets)x\($0.reps))" }.joined(separator: ", ")
        
        return .result(
            dialog: "Workout '\(workoutName)' created with \(workoutExercises.count) exercises.",
            view: WorkoutSnippetView(workout: workout) // Tampilkan UI khusus di Pintasan
        )
    }
}

// -- BARU --
// Tampilan cuplikan khusus untuk ditampilkan dalam UI Pintasan setelah maksud dijalankan.
struct WorkoutSnippetView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.name)
                .font(.headline)
            Text(workout.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Divider()
            ForEach(workout.exercises) { exercise in
                HStack {
                    Text(exercise.name)
                    Spacer()
                    Text("\(exercise.sets) sets x \(exercise.reps) reps")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}


// Penyedia Pintasan tetap sama tetapi sekarang mendukung maksud yang lebih kuat.
struct SportyPlannerShortcuts: AppShortcutsProvider {
    static var shortcutTile = ShortcutTile("Create Workout", systemImageName: "plus")

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddWorkoutIntent(),
            phrases: [
                "Create a workout in ^(appName)",
                "New Workout \(.applicationName) called \(.intent.workoutName)"
            ],
            shortTitle: "Create Workout",
            systemImageName: "dumbbell.fill"
        )
    }
}
