//
//  MatchState.swift
//  RakuApp
//
//  Created by student on 09/06/25.
//

import Foundation
import SwiftUI

class MatchState: ObservableObject {
    @Published var selectedUsers: [MyUser] = []
    @Published var blueScore: Int = 0
    @Published var redScore: Int = 0
    @Published var matchType: MatchType = .single
}

enum MatchType {
    case single
    case doubles
}
