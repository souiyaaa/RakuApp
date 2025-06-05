//
//  MatchDetailModel.swift
//  RakuApp
//
//  Created by student on 05/06/25.
//

import Foundation
import SwiftData

@Model
class MatchDetailModel {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var players: [String]
    var bestOf: Int
    var gameUpTo: Int
    var maxScore: Int
    var blueScore: Int
    var redScore: Int
    var isFinished: Bool

    init(players: [String], bestOf: Int, gameUpTo: Int, maxScore: Int) {
        self.id = UUID()
        self.startTime = Date()
        self.players = players
        self.bestOf = bestOf
        self.gameUpTo = gameUpTo
        self.maxScore = maxScore
        self.blueScore = 0
        self.redScore = 0
        self.isFinished = false
    }
}
