import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    let planner = WorkoutPlanner()

    var body: some View {
        TabView {
            WeekCalendarView()
                .tabItem { Label("Woche", systemImage: "calendar") }

            WorkoutListView()
                .tabItem { Label("Workouts", systemImage: "dumbbell.fill") }

            CardioListView()
                .tabItem { Label("Cardio", systemImage: "figure.run") }

            SettingsView()
                .tabItem { Label("Einstellungen", systemImage: "gear") }
        }
        .tint(.accentColor)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.accentColor.opacity(0.15), for: .tabBar)
        .onAppear(perform: setupInitialData)
    }
    
    private func setupInitialData() {
        // Prüfen, ob bereits Daten vorhanden sind, um Duplikate zu vermeiden
        let descriptor = FetchDescriptor<Workout>()
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        
        if count == 0 {
            // Generierte Workouts einfügen
            for workout in planner.generatePlan() {
                modelContext.insert(workout)
            }
            // Beispiel-Cardio-Einheit mit Route einfügen
            let runningSession = planner.generateSampleCardio()
            modelContext.insert(runningSession)
        }
    }
}
