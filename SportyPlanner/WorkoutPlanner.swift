import Foundation

/// Placeholder planner that would use a local LLM to generate a schedule.
struct WorkoutPlanner {
    /// Generates a simple plan of upcoming workouts.
    func generatePlan() -> [Workout] {
        // In a real implementation this would call a local LLM to generate the plan.
        let exampleExercise = Exercise(name: "Push Ups", sets: 3, reps: 12)
        let workout = Workout(name: "Example Workout", date: Date(), exercises: [exampleExercise])
        return [workout]
    }
}
