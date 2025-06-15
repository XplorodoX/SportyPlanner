import SwiftUI
import SwiftData

@main
struct SportyPlannerApp: App {
    @State private var showingSplash = true

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self,
            Exercise.self,
            CardioSession.self,
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            // If the persistent store cannot be loaded (e.g. after a model change),
            // fall back to an in-memory container so the app can still run.
            print("ModelContainer could not be loaded: \(error). Using in-memory store as fallback.")
            let memoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [memoryConfig])
            } catch {
                fatalError("Could not create in-memory ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            if showingSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                showingSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
                    .onAppear(perform: requestHealthKitAccess)
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func requestHealthKitAccess() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if !success {
                print("HealthKit-Zugriff wurde verweigert oder ist fehlgeschlagen.")
            }
        }
    }
}
