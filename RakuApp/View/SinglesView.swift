//
//  SinglesView.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import SwiftUI
import SwiftData

struct SinglesView: View {
    @EnvironmentObject var matchVM: MatchDetailViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var player1: String = ""
    @State private var player2: String = ""
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
            }
            .padding(.horizontal)

            VStack(spacing: 10) {
                SettingRow(title: "Best of", value: $bestOf)
                SettingRow(title: "Game up to", value: $gameUpTo, highlighted: true)
                SettingRow(title: "Max Score", value: $maxScore)
            }
            .padding(.horizontal)

            Button(action: {
                let players = [player1, player2]
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
        .navigationTitle("Singles")
    }
}

struct SettingRow: View {
    var title: String
    @Binding var value: Int
    var highlighted: Bool = false

    var body: some View {
        HStack {
            Text("\(title): \(value)")
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading)
            Spacer()
            HStack(spacing: 0) {
                Button(action: {
                    if value > 1 { value -= 1 }
                }) {
                    Text("−")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 24, weight: .medium))
                }
                Divider()
                    .frame(height: 24)
                Button(action: {
                    value += 1
                }) {
                    Text("+")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 24, weight: .medium))
                }
            }
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.trailing)
        }
        .frame(height: 60)
        .background(highlighted ? Color(UIColor.systemGray5) : Color.clear)
        .cornerRadius(12)
    }
}

#Preview {
    SinglesView()
        .environmentObject(MatchDetailViewModel())
}
