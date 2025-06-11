//
//  HealthKitManager.swift
//  RakuWatch Watch App
//
//  Created by Surya on 04/06/25.
//

import Foundation
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()

    func requestAuthorization() async throws -> Bool {
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
//    ini watch

    func fetchTodayCalories() async -> Double {
        let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        return await fetchSum(for: type, unit: .kilocalorie())
    }

    func fetchTodayExerciseTime() async -> Double {
        let type = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        return await fetchSum(for: type, unit: .minute())
    }

    func fetchStandingTime() async -> Double {
        let type = HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
        return await fetchSum(for: type, unit: .minute())
    }

    private func fetchSum(for type: HKQuantityType, unit: HKUnit) async -> Double {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                let value = result?.sumQuantity()?.doubleValue(for: unit) ?? 0.0
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }
}

