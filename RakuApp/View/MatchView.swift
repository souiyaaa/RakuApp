//
//  MatchView.swift
//  RakuApp
//
//  Created by Surya on 22/05/25.
//
import SwiftUI

struct MatchView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var matchVM: MatchViewModel

    var body: some View {
        NavigationStack {
            if authVM.isSignedIn && !authVM.userViewModel.myUserData.name.isEmpty{
                VStack {
                    // Row pertama
                    HStack {
                        Image("account")
                        VStack(alignment: .leading) {
                            HStack {
                                
                                Text(
                                    "\(authVM.userViewModel.myUserData.name.isEmpty ? "User" : authVM.userViewModel.myUserData.name) you are at"
                                )
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                Spacer()
                                
                                
                            }
                            HStack {
                                Text(matchVM.userLocationDescription)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Button(action: {
                                matchVM.refreshLocation()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise.circle")
                                    Text("Refresh Location")
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        

                        
                        Button("Logout") {
                            authVM.signOut()
                        }
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                    }
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("Matches")
                .navigationBarTitleDisplayMode(.large)
            }
        }.onAppear {
            print(
                "DEBUG (onAppear): Loaded user → \(authVM.userViewModel.myUserData)"
            )
            authVM.checkUserSession()
        }
    }
}

#Preview {
    let userVM = UserViewModel()
    let authVM = AuthViewModel(userViewModel: userVM)
    let matchVM = MatchViewModel()

    return MatchView()
        .environmentObject(authVM)
        .environmentObject(matchVM)
}
