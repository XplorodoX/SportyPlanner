//
//  WorkoutDetailView.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 14.06.25.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        List {
            Section("Übungen") {
                ForEach(workout.exercises) { exercise in
                    VStack(alignment: .leading) {
                        Text(exercise.name)
                            .font(.headline)
                        Text("\(exercise.sets) Sätze x \(exercise.reps) Wiederholungen")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(workout.name)
    }
}
