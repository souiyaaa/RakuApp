//
//  ActivityViewModel.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import Foundation
import HealthKit

@MainActor
class ActivityViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    
    @Published var calories: Double = 0.0
    @Published var standingTime: Double = 0.0
    @Published var exerciseTime: Double = 0.0

    
    func fetchData() async {
        self.calories = await healthKitManager.fetchTodayCalories()
        self.standingTime = await healthKitManager.fetchStandingTime()
        self.exerciseTime = await healthKitManager.fetchTodayExerciseTime()

    }
    func formattedCalories(_ calories: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: calories)) ?? "\(calories)"
    }


}
