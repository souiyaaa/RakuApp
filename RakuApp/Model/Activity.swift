//
//  Activity.swift
//  RakuApp
//
//  Created by Surya on 03/06/25.
//

import Foundation

struct Activity: Identifiable, Codable {
    var id = UUID().uuidString
    var userId: String
    var calories: Double      // from HealthKit (.activeEnergyBurned)
    var exerciseMinutes: Double  // from HealthKit (.appleExerciseTime)
    var standingMinutes: Double  // from HealthKit (.appleStandTime)
    var date: Date
    
}
