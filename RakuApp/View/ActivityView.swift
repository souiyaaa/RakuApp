//
//  ActivityView.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        Color.white
                            .cornerRadius(20)

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Image(systemName: "tennis.racket")
                                        .resizable()
                                        .frame(width: 23, height: 22)
                                        .foregroundColor(.yellow)
                                    Text("Kezia Allen")
                                        .font(.body)
                                        .bold()
                                }
                                Text("Surabaya, Indonesia")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()

                            Spacer()

                            ZStack {
                                Color(
                                    red: 237 / 255,
                                    green: 237 / 255,
                                    blue: 237 / 255
                                )
                                .cornerRadius(20)
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 18)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 37, height: 26)
                            .padding(.trailing, 14)
                        }
                    }
                    .frame(width: 393, height: 64)
                    .padding(.top, 20)
                    WeeklySumView()
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

#Preview {
    ActivityView()
}
