// souiyaaa/rakuapp/RakuApp-b4efc2de3e01e479eee184089dffb9fa47c7af7d/RakuApp/ViewModel/CalendarViewModel.swift

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var selectedMonth: Int
    @Published var selectedYear: Int
    @Published var selectedDay: Date?
    @Published var daysInMonth: [CalendarModel] = []

    private let calendar = Calendar.current
    
    var currentYear: Int {
        calendar.component(.year, from: Date())
    }

    init() {
        let now = Date()
        self.selectedMonth = calendar.component(.month, from: now)
        self.selectedYear = calendar.component(.year, from: now)
        self.selectedDay = now
        updateDays()
    }

    func updateDays() {
        var components = DateComponents()
        components.month = selectedMonth
        components.year = selectedYear
        components.day = 1

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
    }
}
