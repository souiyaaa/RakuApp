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
    @StateObject private var authVM = AuthViewModel(userViewModel: UserViewModel())
    @StateObject private var userVM = UserViewModel()
    @StateObject private var matchVM = MatchViewModel()
    
    init(){
        FirebaseApp.configure()
        
    #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
    #endif
        
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authVM)
                .environmentObject(userVM)
                .environmentObject(matchVM)
        }
    }
}
