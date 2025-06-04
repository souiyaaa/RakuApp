//
//  HealthManager.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()

    func requestAuthorization() async throws -> Bool{

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!
        ]
    
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }else{
                    continuation.resume(returning: success)
                }
            }
        }
    }
    func fetchTodayCalories()async -> Double{
        let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay,end:now,options:.strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum){
                _,result,_ in
                guard let result = result, let sum = result.sumQuantity() else{
                    continuation.resume(returning: 0.0)
                    return
                }
                let calories = sum.doubleValue(for: HKUnit.kilocalorie())
                
                continuation.resume(returning: calories)
            }
            healthStore.execute(query)
        }
    }
    
    func fetchTodayExerciseTime()async -> Double{
        let excTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay,end:now,options:.strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: excTime, quantitySamplePredicate: predicate, options: .cumulativeSum){
                _,result,_ in
                guard let result = result, let sum = result.sumQuantity() else{
                    continuation.resume(returning: 0.0)
                    return
                }
                let time = sum.doubleValue(for: HKUnit.minute())

                continuation.resume(returning: time)
            }
            healthStore.execute(query)
        }
    }
    
    func fetchStandingTime()async -> Double{
        let standingTime = HKObjectType.quantityType(forIdentifier: .appleStandTime)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay,end:now,options:.strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: standingTime, quantitySamplePredicate: predicate, options: .cumulativeSum){
                _,result,_ in
                guard let result = result, let sum = result.sumQuantity() else{
                    continuation.resume(returning: 0.0)
                    return
                }
                let standtime = sum.doubleValue(for: HKUnit.minute())

                continuation.resume(returning: standtime)
            }
            healthStore.execute(query)
        }
    }
}
