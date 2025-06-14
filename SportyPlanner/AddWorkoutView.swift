//
//  AddWorkoutView.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 15.06.25.
//

import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var exercises: [Exercise] = []

    // State für eine neue Übung
    @State private var exerciseName: String = ""
    @State private var sets: Int = 3
    @State private var reps: Int = 10

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Workout-Details")) {
                    TextField("Name des Workouts", text: $name)
                    DatePicker("Datum", selection: $date, displayedComponents: .date)
                }

                Section(header: Text("Übungen")) {
                    ForEach(exercises) { exercise in
                        HStack {
                            Text(exercise.name)
                            Spacer()
                            Text("\(exercise.sets)x\(exercise.reps)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteExercise)

                    // Formular zum Hinzufügen einer neuen Übung
                    HStack {
                        TextField("Neue Übung", text: $exerciseName)
                        Stepper("Sätze: \(sets)", value: $sets, in: 1...20)
                        Stepper("Wdh: \(reps)", value: $reps, in: 1...100)
                    }
                    Button("Übung hinzufügen", action: addExercise)
                        .disabled(exerciseName.isEmpty)
                }
            }
            .navigationTitle("Neues Workout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveWorkout()
                        dismiss()
                    }
                    .disabled(name.isEmpty || exercises.isEmpty)
                }
            }
        }
    }

    private func addExercise() {
        let newExercise = Exercise(name: exerciseName, sets: sets, reps: reps)
        exercises.append(newExercise)
        // Reset fields
        exerciseName = ""
        sets = 3
        reps = 10
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }

    private func saveWorkout() {
        let newWorkout = Workout(name: name, date: date, exercises: exercises)
        modelContext.insert(newWorkout)
        HealthKitManager.shared.saveWorkout(newWorkout)
    }
}
