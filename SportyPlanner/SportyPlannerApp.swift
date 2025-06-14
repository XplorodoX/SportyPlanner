import SwiftUI
import SwiftData

@main
struct SportyPlannerApp: App {
    // State, um den Zustand des Splash Screens zu steuern
    @State private var showingSplash = true

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self,
            Exercise.self,
            CardioSession.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if showingSplash {
                SplashScreenView()
                    .onAppear {
                        // Nach 2.5 Sekunden zur Hauptansicht wechseln
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showingSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
