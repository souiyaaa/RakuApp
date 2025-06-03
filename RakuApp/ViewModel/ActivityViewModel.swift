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
    
    func fetchData() async {
        self.calories = await healthKitManager.fetchTodayCalories()
    }
}
