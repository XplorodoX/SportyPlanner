//
//  HealthKitManager.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 15.06.25.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    private init() { }

    /// Fordert die Berechtigung vom Benutzer an, auf Gesundheitsdaten zuzugreifen und diese zu schreiben.
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil) // HealthKit ist auf diesem Gerät nicht verfügbar
            return
        }

        let typesToShare: Set = [
            HKObjectType.workoutType()
        ]
        
        let typesToRead: Set = [
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    /// Speichert ein Cardio-Training in Apple Health.
    func saveCardioSession(_ session: CardioSession) {
        let workoutType: HKWorkoutActivityType = session.type == .running ? .running : .cycling
        
        let workout = HKWorkout(
            activityType: workoutType,
            start: session.date,
            end: session.date.addingTimeInterval(session.duration)
        )

        healthStore.save(workout) { success, error in
            if let error = error {
                print("Fehler beim Speichern des Cardio-Workouts in HealthKit: \(error.localizedDescription)")
            }
            if success {
                print("Cardio-Workout erfolgreich in HealthKit gespeichert!")
            }
        }
    }
    
    /// Speichert ein Kraft-Workout in Apple Health.
    func saveWorkout(_ workout: Workout) {
        let totalDuration = workout.exercises.reduce(0.0) { $0 + Double($1.sets * $1.reps) * 5.0 } // Annahme: 5 Sekunden pro Wiederholung
        
        let hkWorkout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: workout.date,
            end: workout.date.addingTimeInterval(totalDuration)
        )
        
        healthStore.save(hkWorkout) { success, error in
            if let error = error {
                print("Fehler beim Speichern des Kraft-Workouts in HealthKit: \(error.localizedDescription)")
            }
            if success {
                print("Kraft-Workout erfolgreich in HealthKit gespeichert!")
            }
        }
    }
}
