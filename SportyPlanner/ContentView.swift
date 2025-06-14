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
            WorkoutListView()
                .tabItem { Label("Workouts", systemImage: "dumbbell") }

            CardioListView()
                .tabItem { Label("Cardio", systemImage: "figure.run") }

            NavigationStack {
                WeekCalendarView()
            }
                .tabItem { Label("Week", systemImage: "calendar") }
        }
        .onAppear {
            if ((try? modelContext.fetch(FetchDescriptor<Workout>()).isEmpty ?? true) != nil) {
                for workout in planner.generatePlan() {
                    modelContext.insert(workout)
                }
            }
        }
    }

    // Old list manipulation is removed in favour of dedicated views.
}
