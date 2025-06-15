import AppIntents
import Foundation

struct ExerciseEntity: AppEntity, AppValue, Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var sets: Int
    var reps: Int

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Exercise")
    }
    static var typeDisplayName: LocalizedStringResource {
        "Exercise"
    }
    static var defaultQuery: ExerciseQuery {
        ExerciseQuery()
    }
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: name),
            subtitle: LocalizedStringResource(stringLiteral: "\(sets) sets x \(reps) reps")
        )
    }
    
    init(id: UUID = UUID(), name: String, sets: Int, reps: Int) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}

struct ExerciseQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [ExerciseEntity] {
        return []
    }

    func suggestedEntities() async throws -> [ExerciseEntity] {
        return [
            ExerciseEntity(name: "Bench Press", sets: 3, reps: 10),
            ExerciseEntity(name: "Squats", sets: 4, reps: 8),
            ExerciseEntity(name: "Deadlift", sets: 1, reps: 5)
        ]
    }
}
