import SwiftUI

struct ScoreboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var matchState: MatchState

    @State private var blueScore = 0
    @State private var redScore = 0
    @State private var activePlayer = "Player 1"
    @State private var setNumber = 1
    @State private var gameOver = false
    @State private var winnerColor: Color? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Color.blue
                        VStack {
                            teamBox(color: .blue, names: teamNames(isBlue: true))
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
                            teamBox(color: .red, names: teamNames(isBlue: false))
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
                            presentationMode.wrappedValue.dismiss()
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
            .contentShape(Rectangle())
            .onTapGesture {
                if gameOver {
                    presentationMode.wrappedValue.dismiss()
                }
            }
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

    func teamNames(isBlue: Bool) -> [String] {
        let users = matchState.selectedUsers
        if matchState.matchType == .single {
            return [isBlue ? users.first?.name ?? "" : users.dropFirst().first?.name ?? ""]
        } else {
            return isBlue ? Array(users.prefix(2)).map { $0.name } : Array(users.dropFirst(2)).map { $0.name }
        }
    }
}

#Preview {
    ScoreboardView(matchState: MatchState())
}
