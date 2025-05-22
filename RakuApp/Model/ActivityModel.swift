//
//  ActivityModel.swift
//  RakuApp
//
//  Created by student on 22/05/25.
//

import Foundation

struct ActivityModel: Identifiable, Hashable, Codable{
    var id: Int
    var TotalEnergyBurned: Int
    var ExerciseTime: Int
    var TotalStandingTime: Int
    var TotalGame: Int
}
    
