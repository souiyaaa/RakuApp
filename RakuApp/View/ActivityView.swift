//
//  ActivityView.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var matchVM: MatchViewModel


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    GeometryReader { geo in
                        let height: CGFloat = 64
                        let totalWidth = geo.size.width

                        ZStack {
                            Color.white
                                .cornerRadius(20)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
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

                                        Text(
                                            "\(authVM.userViewModel.myUserData.name.isEmpty ? "User" : authVM.userViewModel.myUserData.name) you are at"
                                        )
                                            .font(.body)
                                            .bold()
                                    }

                                    Text(matchVM.userLocationDescription)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading)

                                Spacer()

                                ZStack {
                                    Color(
                                        red: 237 / 255,
                                        green: 237 / 255,
                                        blue: 237 / 255
                                    )
                                    .cornerRadius(20)
                                    
                                    Button(action: {
                                        matchVM.refreshLocation()
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.clockwise")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: height * 0.28)
                                                .foregroundColor(.black)
                                        }
                                    }
                                   
                                }
                                .frame(
                                    width: totalWidth * 0.09,
                                    height: height * 0.4
                                )
                                .padding(.trailing)
                            }
                            .frame(height: height)
                        }
                        .frame(height: height)
                    }
                    .frame(height: 64)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    WeeklySumView(activityVM: _activityVM)
                    Text("Leaderboard")
                        .font(.headline)
                        .padding(.horizontal)
                    LeaderboardView()
                    LeaderboardCard()
                }
                .padding(.vertical)
            }

            .background(
                Color(red: 247 / 255, green: 247 / 255, blue: 247 / 255)
            )

            .navigationTitle("Activity")
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
