//
//  CurrentMatch.swift
//  RakuApp
//
//  Created by student on 11/06/25.
//

import Foundation
import SwiftData

@Model
class CurrentMatch: Identifiable {
    var id: String = UUID().uuidString
    var userID: String
    var matchType: String
    var playerNames: [String]
    var gameUpTo: Int
    var maxScore: Int
    var blueScore: Int
    var redScore: Int
    var timestamp: Date

    init(userID: String, matchType: String, playerNames: [String], gameUpTo: Int, maxScore: Int, blueScore: Int, redScore: Int, timestamp: Date = Date()) {
        self.userID = userID
        self.matchType = matchType
        self.playerNames = playerNames
        self.gameUpTo = gameUpTo
        self.maxScore = maxScore
        self.blueScore = blueScore
        self.redScore = redScore
        self.timestamp = timestamp
    }
}
