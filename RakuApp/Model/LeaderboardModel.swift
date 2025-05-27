//
//  LeaderboardModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//


import Foundation

struct LeaderboardModel: Identifiable {
    let id: String 
    let rank: Int
    let name: String
    let points: Int
    let isCurrentUser: Bool
}
