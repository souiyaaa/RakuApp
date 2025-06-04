//
//  WatchActivityViewModel.swift
//  RakuWatch Watch App
//
//  Created by Surya on 04/06/25.
//

import Foundation


@MainActor
class WatchActivityViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()

    @Published var calories: Double = 0.0
    @Published var standingTime: Double = 0.0
    @Published var exerciseTime: Double = 0.0

    func requestHealthAuthorization() async {
        do {
            let granted = try await healthKitManager.requestAuthorization()
            if granted {
                await fetchActivityData()
            } else {
                print("HealthKit permission denied.")
            }
        } catch {
            print("HealthKit error: \(error.localizedDescription)")
        }
    }

    func fetchActivityData() async {
        calories = await healthKitManager.fetchTodayCalories()
        standingTime = await healthKitManager.fetchStandingTime()
        exerciseTime = await healthKitManager.fetchTodayExerciseTime()
    }
}
