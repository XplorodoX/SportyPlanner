import AppIntents
import SwiftData

/// Intent to create a new workout so it can be triggered from Shortcuts or Siri.
struct AddWorkoutIntent: AppIntent {
    static var title: LocalizedStringResource = "Workout anlegen"
    static var description = IntentDescription("Erstellt ein neues Workout in SportyPlanner.")

    @Parameter(title: "Name")
    var workoutName: String

    @Parameter(title: "Datum")
    var date: Date

    @Parameter(title: "Übung", default: "")
    var exerciseName: String

    @Parameter(title: "Sätze", default: 3)
    var sets: Int

    @Parameter(title: "Wiederholungen", default: 10)
    var reps: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Workout \(\.$workoutName) am \(\.$date)") {
            \.$exerciseName
        }
    }

    func perform() async throws -> some IntentResult {
        let container = PersistenceController.shared.container
        let context = ModelContext(container)

        var exercises: [Exercise] = []
        if !exerciseName.isEmpty {
            exercises.append(Exercise(name: exerciseName, sets: sets, reps: reps))
        }
        let workout = Workout(name: workoutName, date: date, exercises: exercises)
        context.insert(workout)
        HealthKitManager.shared.saveWorkout(workout)
        return .result(dialog: "Workout angelegt")
    }
}

struct SportyPlannerShortcuts: AppShortcutsProvider {
    static var shortcutTile = ShortcutTile("Workout anlegen", systemImageName: "plus")

    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: AddWorkoutIntent(), phrases: ["Workout in ^App anlegen", "Neues Workout \(.intent.workoutName) in ^App"])
    }
}
