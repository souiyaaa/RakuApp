//
//  CalendarViewModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var selectedMonth: Int
    @Published var selectedDay: Date?
    @Published var daysInMonth: [CalendarModel] = []

    private let calendar = Calendar.current

    init() {
        self.selectedMonth = calendar.component(.month, from: Date())
        updateDays()
    }

    func updateDays() {
        var components = DateComponents()
        components.month = selectedMonth
        components.day = 1
        components.year = calendar.component(.year, from: Date()) // Tambahkan tahun agar pasti benar

        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return
        }

        daysInMonth = range.compactMap { day -> CalendarModel? in
            var dateComponents = components
            dateComponents.day = day
            if let date = calendar.date(from: dateComponents) {
                let dayName = date.formatted(.dateTime.weekday(.abbreviated))
                let dayNumber = String(day)
                return CalendarModel(date: date, dayName: dayName, dayNumber: dayNumber)
            }
            return nil
        }

        selectedDay = nil
    }
}
