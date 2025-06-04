//
//  MainView.swift
//  RakuApp
//
//  Created by Surya on 22/05/25.
//

import SwiftUI
struct MainView: View {
    
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if !authVM.isSignedIn {
                AnyView(SplashView())
            } else {
                AnyView(
                    TabView {
                        MatchView()
                            .tabItem {
                                Image(systemName: "sportscourt.fill")
                                Text("Matches")
                            }

                        VideoView()
                            .tabItem {
                                Image(systemName: "book.pages.fill")
                                Text("Learn")
                            }

                        ActivityView()
                            .tabItem {
                                Image(systemName: "figure.badminton")
                                Text("Activity")
                            }
                    }
                )
            }
        }
    }
}


#Preview {
    let userVM = UserViewModel()
    let authVM = AuthViewModel(userViewModel: userVM)

    MainView()
        .environmentObject(authVM)
}
