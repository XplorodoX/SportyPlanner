import SwiftData

/// Provides a shared `ModelContainer` that can be used throughout the app and by
/// App Intents.
class PersistenceController {
    static let shared = PersistenceController()
    let container: ModelContainer

    private init() {
        let schema = Schema([
            Workout.self,
            Exercise.self,
            CardioSession.self,
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("ModelContainer could not be loaded: \(error). Using in-memory store as fallback.")
            let memoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            container = try! ModelContainer(for: schema, configurations: [memoryConfig])
        }
    }
}
