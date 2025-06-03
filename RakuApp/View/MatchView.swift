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

    @State var isAddEvent = false

    var body: some View {
        NavigationStack {
            VStack {
                // Row pertama
                HStack {
                    if let uiImage = authVM.userViewModel.myUserPicture {
                           Image(uiImage: uiImage)
                               .resizable()
                               .scaledToFill()
                               .frame(width: 50, height: 50)
                               .clipShape(Circle())
                       } else {
                           Image(systemName: "person.crop.circle.fill") // fallback system image
                               .resizable()
                               .frame(width: 50, height: 50)
                               .foregroundColor(.gray)
                       }
                    
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

                HStack {
                    Text("Current match")
                    Spacer()
                    Button("More") {
                        //more detail here
                    }
                    .foregroundColor(Color(hex: "253366"))
                    .font(.headline)

                }
                .padding(.horizontal, 20)

                HStack {
                    Text("Events")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 4)

                HStack {
                    Button(action: {
                        // action here
                    }) {
                        Text("Aug >")
                            .foregroundColor(Color(hex: "253366"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(12)  // rounded corners
                            .shadow(
                                color: Color.black.opacity(0.1), radius: 4,
                                x: 0, y: 2)  // gentle shadow
                    }

                    Spacer()

                    Button(action: {
                        isAddEvent = true
                    }) {
                        Text("Add Events")
                            .foregroundColor(Color(hex: "253366"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(12)  // rounded corners
                            .shadow(
                                color: Color.black.opacity(0.1), radius: 4,
                                x: 0, y: 2)  // gentle shadow
                    }
                }
                .padding(.horizontal, 16)

                Spacer()
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isAddEvent) {
                NavigationStack {
                    AddNewEventView(isAddEvent: $isAddEvent)
                }
            }
        }
        .onAppear {
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
