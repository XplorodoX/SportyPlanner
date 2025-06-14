//
//  ContentView.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 14.06.25.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    let planner = WorkoutPlanner()

    var body: some View {
        TabView {
            NavigationStack {
                WeekCalendarView()
            }
            .tabItem { Label("Woche", systemImage: "calendar") }

            WorkoutListView()
                .tabItem { Label("Workouts", systemImage: "dumbbell.fill") }

            CardioListView()
                .tabItem { Label("Cardio", systemImage: "figure.run") }
        }
        .onAppear {
            if ((try? modelContext.fetch(FetchDescriptor<Workout>()).isEmpty ?? true) != nil) {
                for workout in planner.generatePlan() {
                    modelContext.insert(workout)
                }
            }
        }
    }
}
