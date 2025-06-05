//
//  MatchDetailView.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import SwiftUI

struct MatchDetailView: View {
    @EnvironmentObject var matchVM: MatchDetailViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 4) {
                        Text("YOU ARE")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.5))
                        Text("INVITED")
                            .font(.title2)
                            .italic()
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .red.opacity(0.2),
                                .orange.opacity(0.2),
                                .yellow.opacity(0.2),
                                .green.opacity(0.2),
                                .blue.opacity(0.2),
                                .purple.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .ignoresSafeArea(edges: .horizontal)

                    // Match Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Saturday Morning Match")
                            .font(.title2).bold()
                        Text("Central Park Court 3")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(spacing: -10) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 30, height: 30)
                                    .overlay(Text("P\(index + 1)").foregroundColor(.white))
                            }
                            Text("+2")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Text("5 Participants")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Actions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What do you want to do?")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 16) {
                            ActionButtonView(color: .green, icon: "sportscourt", label: "Be Referee")

                            NavigationLink(destination: SinglesView()) {
                                ActionButtonView(color: .blue, icon: "person", label: "Singles")
                            }

                            NavigationLink(destination: DoublesView()) {
                                ActionButtonView(color: .orange, icon: "person.2", label: "Doubles")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Current Match
                    if let match = matchVM.matches.first {
                        NavigationLink(destination: ScoreboardView(match: match).environmentObject(matchVM)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Current Matches")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                ForEach(matchVM.matches) { match in
                                    NavigationLink(destination: ScoreboardView(match: match).environmentObject(matchVM)) {
                                        VStack(spacing: 8) {
                                            HStack {
                                                // 왼쪽 팀 (Player 1 & 2)
                                                VStack(alignment: .leading) {
                                                    if match.players.indices.contains(0) {
                                                        Text(match.players[0])
                                                    }
                                                    if match.players.indices.contains(1) && match.players.count >= 4 {
                                                        Text(match.players[1])
                                                    }
                                                }
                                                .font(.caption)
                                                .foregroundColor(.white)

                                                Spacer()

                                                // 점수
                                                Text("\(match.blueScore)")
                                                    .font(.title)
                                                    .bold()
                                                    .foregroundColor(.white)

                                                Spacer()

                                                Text("\(match.redScore)")
                                                    .font(.title)
                                                    .bold()
                                                    .foregroundColor(.white)

                                                Spacer()

                                                // 오른쪽 팀 (Player 2 or Player 3 & 4)
                                                VStack(alignment: .trailing) {
                                                    if match.players.count == 2 {
                                                        Text(match.players[1])
                                                    } else if match.players.count >= 4 {
                                                        if match.players.indices.contains(2) {
                                                            Text(match.players[2])
                                                        }
                                                        if match.players.indices.contains(3) {
                                                            Text(match.players[3])
                                                        }
                                                    }
                                                }
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            }
                                            .padding()
                                            .background(Color(red: 0.0, green: 0.2, blue: 0.5))
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }


                    // History
                    VStack(alignment: .leading, spacing: 8) {
                        Text("History")
                            .font(.headline)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Saturday Morning Match")
                                    .font(.subheadline).bold()
                                Text("Double - 3 Set")
                                    .font(.caption)
                            }
                            Spacer()
                            Text("5 Participants")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Current Match")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ActionButtonView: View {
    var color: Color
    var icon: String
    var label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(color.opacity(0.2))
                .clipShape(Circle())

            Text(label)
                .font(.footnote)
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(color.opacity(1))
        .cornerRadius(20)
    }
}

#Preview {
    MatchDetailView()
        .environmentObject(MatchDetailViewModel())
}
