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
    @StateObject private var authVM = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
        
    #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
    #endif
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}
