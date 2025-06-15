import AppIntents
import Foundation

/// Struct representing a single exercise that can be used with Shortcuts.
/// The properties are simple stored values so the type remains `Sendable`.
struct ExerciseEntity: AppEntity, Identifiable, Hashable, Sendable {
    /// Unique identifier used by Shortcuts.
    let id: UUID

    /// Name of the exercise.
    var name: String

    /// Number of sets.
    var sets: Int

    /// Number of repetitions.
    var reps: Int

    /// How the type itself is shown in the Shortcuts UI.
    nonisolated(unsafe) static var typeDisplayRepresentation: TypeDisplayRepresentation = "Exercise"

    /// Representation for a concrete value when shown in Shortcuts.
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: name, subtitle: "\(sets) sets x \(reps) reps")
    }

    /// Default query used by the Shortcuts app.
    nonisolated(unsafe) static var defaultQuery = ExerciseQuery()
    nonisolated(unsafe) static var typeDisplayName: LocalizedStringResource = "Exercise"

    init(id: UUID = UUID(), name: String, sets: Int, reps: Int) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}

// Kueri tetap sama.
struct ExerciseQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [ExerciseEntity] {
        // Karena latihan tidak disimpan secara independen, kita tidak mengambilnya.
        // Ini terutama untuk pembuatan.
        return []
    }

    func suggestedEntities() async throws -> [ExerciseEntity] {
        // Anda dapat menyarankan latihan umum di sini
        return [
            ExerciseEntity(name: "Bench Press", sets: 3, reps: 10),
            ExerciseEntity(name: "Squats", sets: 4, reps: 8),
            ExerciseEntity(name: "Deadlift", sets: 1, reps: 5)
        ]
    }
}

// `ExerciseEntity` is used as an intent parameter, so no additional
// conformance beyond `AppEntity` is required.
