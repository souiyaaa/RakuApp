//
//  RakuAppApp.swift
//  RakuApp
//
//  Created by Surya on 21/05/25.
//

import SwiftUI
import FirebaseAppCheck
import Firebase

@main
struct RakuAppApp: App {
    @StateObject private var userVM: UserViewModel
    @StateObject private var authVM: AuthViewModel
    @StateObject private var matchVM = MatchViewModel()
    @StateObject private var gameVM: GameViewModel
    @StateObject private var gripVM = GripViewModel()
    @StateObject private var activityVM: ActivityViewModel

    init() {
        FirebaseApp.configure()

        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif

        // Dependency injection
        let userVM = UserViewModel()
        _userVM = StateObject(wrappedValue: userVM)

        let authVM = AuthViewModel(userViewModel: userVM)
        _authVM = StateObject(wrappedValue: authVM)

        let gameVM = GameViewModel(userViewModel: userVM)
        _gameVM = StateObject(wrappedValue: gameVM)

        let activityVM = ActivityViewModel(authViewModel: authVM)
        _activityVM = StateObject(wrappedValue: activityVM)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authVM)
                .environmentObject(userVM)
                .environmentObject(matchVM)
                .environmentObject(gameVM)
                .environmentObject(gripVM)
                .environmentObject(activityVM)
        }
    }
}
