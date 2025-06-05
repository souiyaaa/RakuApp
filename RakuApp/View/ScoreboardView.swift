//  ScoreboardView.swift
//  RakuApp
//
//  Created by student on 03/06/25.

import SwiftUI
import SwiftData

struct ScoreboardView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var matchVM: MatchDetailViewModel

    @State private var blueScore = 0
    @State private var redScore = 0
    @State private var activePlayer = "Player 1"
    @State private var setNumber = 1
    @State private var gameOver = false
    @State private var winnerColor: Color? = nil

    var match: MatchDetailModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Color.blue
                        VStack {
                            let leftPlayers = match.players.count == 2 ? [match.players[0]] : Array(match.players.prefix(2))
                            teamBox(color: .blue, names: leftPlayers)
                            Spacer()
                            Text("\(blueScore)")
                                .font(.system(size: 120, weight: .bold))
                                .foregroundColor(.white)
                            HStack(spacing: 40) {
                                Button("−") {
                                    if blueScore > 0 { blueScore -= 1 }
                                }
                                .font(.largeTitle)
                                Button("+") {
                                    increaseScore(team: .blue)
                                }
                                .font(.largeTitle)
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                    }
                    .onTapGesture {
                        increaseScore(team: .blue)
                    }

                    ZStack(alignment: .topTrailing) {
                        Color.red
                        VStack {
                            let rightPlayers = match.players.count == 2 ? [match.players[1]] : Array(match.players.dropFirst(2))
                            teamBox(color: .red, names: rightPlayers)
                            Spacer()
                            Text("\(redScore)")
                                .font(.system(size: 120, weight: .bold))
                                .foregroundColor(.white)
                            HStack(spacing: 40) {
                                Button("−") {
                                    if redScore > 0 { redScore -= 1 }
                                }
                                .font(.largeTitle)
                                Button("+") {
                                    increaseScore(team: .red)
                                }
                                .font(.largeTitle)
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                    }
                    .onTapGesture {
                        increaseScore(team: .red)
                    }
                }
                .overlay(alignment: .top) {
                    HStack {
                        Button("Back") {
                            match.blueScore = blueScore
                            match.redScore = redScore
                            try? context.save()
                            dismiss()
                        }
                        .foregroundColor(.blue)
                        Spacer()
                        Text("Scoreboard")
                            .font(.headline)
                        Spacer()
                        Text("SET \(setNumber)")
                            .font(.headline)
                    }
                    .padding()
                    .background(.white.opacity(0.8))
                }
                .overlay(alignment: .bottom) {
                    if !gameOver {
                        Text("Active Player: \(activePlayer)")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                            .padding(.bottom, 8)
                    } else if let winner = winnerColor {
                        Text("\(winner == .blue ? "Blue" : "Red") Wins!")
                            .font(.title)
                            .foregroundColor(winner == .blue ? .blue : .red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                            .padding(.bottom, 8)
                    }
                }
                .rotationEffect(.degrees(90))
                .frame(width: geometry.size.height, height: geometry.size.width)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.77)
            }
            .ignoresSafeArea()
            .onTapGesture {
                if gameOver {
                    match.blueScore = blueScore
                    match.redScore = redScore
                    match.isFinished = true
                    try? context.save()
                    dismiss()
                }
            }
        }
        .onAppear {
            blueScore = match.blueScore
            redScore = match.redScore
        }
    }

    enum TeamColor {
        case blue, red
    }

    func increaseScore(team: TeamColor) {
        guard !gameOver else { return }

        switch team {
        case .blue:
            blueScore += 1
        case .red:
            redScore += 1
        }

        checkGameOver()
    }

    func checkGameOver() {
        if (blueScore >= 21 || redScore >= 21) {
            if abs(blueScore - redScore) >= 2 && max(blueScore, redScore) <= 29 {
                endGame()
            } else if blueScore == 30 || redScore == 30 {
                endGame()
            }
        }
    }

    func endGame() {
        gameOver = true
        winnerColor = blueScore > redScore ? .blue : .red
    }

    @ViewBuilder
    func teamBox(color: Color, names: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(names, id: \.self) { name in
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text(name)
                }
            }
        }
        .padding(8)
        .padding(.top, 34)
        .background(color.opacity(0.2))
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}


#Preview {
    let match = MatchDetailModel(players: ["Alice", "Bob"], bestOf: 1, gameUpTo: 21, maxScore: 30)
    match.blueScore = 0
    match.redScore = 0
    match.isFinished = false
    return ScoreboardView(match: match)
        .environmentObject(MatchDetailViewModel())
}
