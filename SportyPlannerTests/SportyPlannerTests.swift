//
//  SportyPlannerTests.swift
//  SportyPlannerTests
//
//  Created by Florian Merlau on 14.06.25.
//

import Testing
@testable import SportyPlanner

struct SportyPlannerTests {

    @Test func plannerCreatesWorkout() async throws {
        let planner = WorkoutPlanner()
        let plan = planner.generatePlan()
        #expect(plan.isEmpty == false)
    }

}
