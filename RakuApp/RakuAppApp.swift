//
//  RakuAppApp.swift
//  RakuApp
//
//  Created by Surya on 21/05/25.
//

import Firebase
import FirebaseAppCheck
import SwiftUI
import SwiftData // ✅ SwiftData import 추가

@main
struct RakuAppApp: App {
    @StateObject private var userVM = UserViewModel()
    @StateObject private var authVM: AuthViewModel
    @StateObject private var gameVM: GameViewModel
    @StateObject private var matchVM = MatchViewModel()
    @StateObject private var activityVM: ActivityViewModel
    @StateObject private var gripVM = GripViewModel()

    init() {
        FirebaseApp.configure()

        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif

        let userVM = UserViewModel()
        _userVM = StateObject(wrappedValue: userVM)

        let authVM = AuthViewModel(userViewModel: userVM)
        _authVM = StateObject(wrappedValue: authVM)

        _gameVM = StateObject(
            wrappedValue: GameViewModel(userViewModel: userVM)
        )
        _activityVM = StateObject(
            wrappedValue: ActivityViewModel(authViewModel: authVM)
        )
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authVM)
                .environmentObject(userVM)
                .environmentObject(matchVM)
                .environmentObject(gripVM)
                .environmentObject(gameVM)
                .environmentObject(activityVM)
                .modelContainer(for: CurrentMatch.self) // ✅ 여기에 SwiftData 컨테이너 추가
        }
    }
}

