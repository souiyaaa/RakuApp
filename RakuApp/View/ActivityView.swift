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
                    GeometryReader { geo in
                        let height: CGFloat = 64
                        let totalWidth = geo.size.width

                        ZStack {
                            Color.white
                                .cornerRadius(20)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "tennis.racket")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: height * 0.34)  // ±22
                                            .foregroundColor(.yellow)

                                        Text("Kezia Allen")
                                            .font(.body)
                                            .bold()
                                    }

                                    Text("Surabaya, Indonesia")
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

                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: height * 0.28)
                                        .foregroundColor(.black)
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
