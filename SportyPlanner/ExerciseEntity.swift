import AppIntents
import Foundation

// Struk yang mewakili satu latihan dalam suatu maksud.
// DIUBAH: Ditambahkan 'Sendable' untuk memastikan keamanan thread dengan App Intents.
struct ExerciseEntity: AppEntity, Identifiable, Sendable {
    let id: UUID
    
    @Property(title: "Name")
    var name: String
    
    @Property(title: "Sets")
    var sets: Int
    
    @Property(title: "Reps")
    var reps: Int
    
    // Bagaimana entitas akan ditampilkan dalam UI Pintasan
    // DIUBAH: Dihapus 'nonisolated(unsafe)' untuk konkurensi yang lebih bersih.
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Exercise"
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)", subtitle: "\(sets) sets x \(reps) reps")
    }

    // Memberi tahu Pintasan cara mengidentifikasi entitas ini secara unik
    static var defaultQuery = ExerciseQuery()
    static var typeDisplayName: LocalizedStringResource = "Exercise"

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

// Konformasi AppValue sudah menyiratkan kebutuhan akan Sendable,
// jadi ini berfungsi dengan sempurna dengan perbaikan kami.
extension ExerciseEntity: AppValue {}
