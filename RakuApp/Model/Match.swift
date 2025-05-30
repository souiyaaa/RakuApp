//
//  Match.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import Foundation

struct Match: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    var date: Date // date and time directly
    var courtCost: Double
    var players: [MyUser]
    var games: [Game] = []
    var paidUserIds: [String] = [] // user IDs of players who have paid
    var location: String
    
    var costPerPlayer: Double {
        guard !players.isEmpty else { return 0.0 }
        return courtCost / Double(players.count)
    }
}
