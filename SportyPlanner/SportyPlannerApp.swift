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
