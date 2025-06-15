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
                
                // --- BEGINN DER ÄNDERUNGEN ---

                // Der Bereich zum Hinzufügen von Übungen wurde zur besseren Lesbarkeit neu strukturiert.
                Section(header: Text("Neue Übung hinzufügen")) {
                    TextField("Name der Übung", text: $exerciseName)
                    
                    // Stepper sind jetzt für eine bessere Übersicht untereinander angeordnet.
                    Stepper("Sätze: \(sets)", value: $sets, in: 1...20)
                    Stepper("Wiederholungen: \(reps)", value: $reps, in: 1...100)
                    
                    // Der Button ist nun zentriert und optisch hervorgehoben.
                    HStack {
                        Spacer()
                        Button(action: addExercise) {
                            Label("Übung hinzufügen", systemImage: "plus.circle.fill")
                        }
                        .disabled(exerciseName.isEmpty)
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }

                // Die Liste der hinzugefügten Übungen erscheint nur, wenn Übungen vorhanden sind.
                if !exercises.isEmpty {
                    Section(header: Text("Hinzugefügte Übungen")) {
                        ForEach(exercises) { exercise in
                            HStack {
                                Text(exercise.name)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(exercise.sets) Sätze, \(exercise.reps) Wdh.")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: deleteExercise)
                    }
                }
                // --- ENDE DER ÄNDERUNGEN ---
            }
            .navigationTitle("Neues Workout")
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
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
        // Die Funktion bleibt unverändert, fügt aber jetzt in das neue Layout ein.
        let newExercise = Exercise(name: exerciseName, sets: sets, reps: reps)
        withAnimation {
            exercises.append(newExercise)
        }
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
