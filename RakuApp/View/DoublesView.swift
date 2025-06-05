//
//  DoublesView.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import SwiftUI
import SwiftData

struct DoublesView: View {
    @EnvironmentObject var matchVM: MatchDetailViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var player1: String = ""
    @State private var player2: String = ""
    @State private var player3: String = ""
    @State private var player4: String = ""
    @State private var bestOf: Int = 1
    @State private var gameUpTo: Int = 21
    @State private var maxScore: Int = 30

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter Players")
                    .font(.headline)
                TextField("Player 1", text: $player1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Player 2", text: $player2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Player 3", text: $player3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Player 4", text: $player4)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)

            VStack(spacing: 10) {
                SettingRow(title: "Best of", value: $bestOf)
                SettingRow(title: "Game up to", value: $gameUpTo, highlighted: true)
                SettingRow(title: "Max Score", value: $maxScore)
            }
            .padding(.horizontal)

            Button(action: {
                let players = [player1, player2, player3, player4]
                let match = MatchDetailModel(players: players, bestOf: bestOf, gameUpTo: gameUpTo, maxScore: maxScore)

                context.insert(match)
                try? context.save()

                matchVM.matches.insert(match, at: 0)
                matchVM.saveMatchToFirebase(match: match)
                dismiss()
            }) {
                Text("Start Match")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .navigationTitle("Doubles")
    }
}

#Preview {
    DoublesView()
        .environmentObject(MatchDetailViewModel()) // ✅ 추가
}
