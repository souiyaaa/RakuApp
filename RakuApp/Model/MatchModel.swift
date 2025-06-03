//
//  MatchModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import Foundation

struct MatchModel: Codable {
    let id: String
    let eventName: String
    let Desc: String
    let date: Int
    let time: Int
    let cost: Int
    let level: Int
}
