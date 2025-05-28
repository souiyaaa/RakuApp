//
//  CalendarModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import Foundation

struct CalendarModel: Identifiable {
    let id = UUID()
    let date: Date
    let dayName: String
    let dayNumber: String
}
