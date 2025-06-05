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
<<<<<<< Updated upstream
    @StateObject private var authVM = AuthViewModel()
    @StateObject var activityVM = ActivityViewModel()

    init(){
        FirebaseApp.configure()
        
    #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
    #endif
        
=======
    @StateObject private var userVM = UserViewModel()
    @StateObject private var authVM: AuthViewModel
    @StateObject private var gameVM: GameViewModel
    @StateObject private var matchVM = MatchViewModel()
    @StateObject private var activityVM: ActivityViewModel
    @StateObject private var gripVM = GripViewModel()
    
    @StateObject private var matchDetailVM = MatchDetailViewModel()

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

        _gameVM = StateObject(wrappedValue: GameViewModel(userViewModel: userVM))
        _activityVM = StateObject(wrappedValue: ActivityViewModel(authViewModel: authVM))
>>>>>>> Stashed changes
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authVM)
                .environmentObject(activityVM)

                // ✅ 꼭 필요: MatchDetailViewModel 주입
                .environmentObject(matchDetailVM)
        }
    }
}

