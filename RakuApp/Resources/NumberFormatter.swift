//
//  NumberFormatter.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import Foundation
extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
