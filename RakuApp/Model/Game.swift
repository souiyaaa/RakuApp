//
//  Game.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import Foundation

struct Game: Identifiable, Codable {
    var id: String = UUID().uuidString
    var type: String // "single" or "double"
    var leftPlayers: [MyUser]
    var rightPlayers: [MyUser]
    var activePlayer: MyUser?
    var leftScore: Int = 0
    var rightScore: Int = 0
    var bestOf: Int = 1 // default 1 round (best of 1)
    var gameUpTo: Int = 21 // default points to win
    var gameMax: Int = 30 // max points cap
}
