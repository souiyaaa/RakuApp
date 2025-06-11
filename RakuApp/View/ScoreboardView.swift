import SwiftUI
import SwiftData

struct ScoreboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    @ObservedObject var matchState: MatchState

    @State private var setNumber = 1
    @State private var gameOver = false
    @State private var winnerColor: Color? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    scorePanel(isBlue: true)
                    scorePanel(isBlue: false)
                }
                .overlay(topBar, alignment: .top)
                .overlay(bottomBar, alignment: .bottom)
                .rotationEffect(.degrees(90))
                .frame(width: geometry.size.height, height: geometry.size.width)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.77)
            }
            .ignoresSafeArea()
            .onTapGesture {
                if gameOver {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    func scorePanel(isBlue: Bool) -> some View {
        let color: Color = isBlue ? .blue : .red
        let score: Int = isBlue ? matchState.blueScore : matchState.redScore
        let users = matchState.selectedUsers
        let playerNames: [String] = {
            switch matchState.matchType {
            case .single:
                guard users.count == 2 else {
                    return isBlue ? ["Blue"] : ["Red"]
                }
                return isBlue ? [users[0].name] : [users[1].name]
            case .doubles:
                guard users.count == 4 else {
                    return isBlue ? ["Team A1", "Team A2"] : ["Team B1", "Team B2"]
                }
                return isBlue ? [users[0].name, users[1].name] : [users[2].name, users[3].name]
            }
        }()

        return ZStack(alignment: isBlue ? .topLeading : .topTrailing) {
            color
            VStack {
                teamBox(color: color, names: playerNames)
                Spacer()
                Text("\(score)")
                    .font(.system(size: 120, weight: .bold))
                    .foregroundColor(.white)
                HStack(spacing: 40) {
                    Button("−") {
                        if isBlue {
                            matchState.blueScore = max(0, matchState.blueScore - 1)
                        } else {
                            matchState.redScore = max(0, matchState.redScore - 1)
                        }
                        saveScore()
                    }
                    .font(.largeTitle)

                    Button("+") {
                        increaseScore(team: isBlue ? .blue : .red)
                    }
                    .font(.largeTitle)
                }
                .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .onTapGesture {
            increaseScore(team: isBlue ? .blue : .red)
        }
    }

    enum TeamColor { case blue, red }

    func increaseScore(team: TeamColor) {
        guard !gameOver else { return }
        switch team {
        case .blue: matchState.blueScore += 1
        case .red:  matchState.redScore += 1
        }
        saveScore()
        checkGameOver()
    }

    func saveScore() {
        if let currentMatch = matchState.currentMatch {
            currentMatch.blueScore = matchState.blueScore
            currentMatch.redScore = matchState.redScore
            try? context.save()
        }
    }

    func checkGameOver() {
        let gameUpTo = matchState.gameUpTo
        let maxScore = matchState.maxScore
        let diff = abs(matchState.blueScore - matchState.redScore)
        let maxReached = max(matchState.blueScore, matchState.redScore)
        if maxReached >= gameUpTo {
            if diff >= 2 && maxReached < maxScore {
                endGame()
            } else if maxReached == maxScore {
                endGame()
            }
        }
    }

    func endGame() {
        gameOver = true
        winnerColor = matchState.blueScore > matchState.redScore ? .blue : .red
    }

    @ViewBuilder
    func teamBox(color: Color, names: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(names, id: \.self) { name in
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text(name)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .padding(8)
        .padding(.top, 34)
        .background(color.opacity(0.2))
        .cornerRadius(12)
        .foregroundColor(.white)
    }

    var topBar: some View {
        HStack {
            Button("Back") {
                saveScore()
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.blue)
            Spacer()
            Text("Scoreboard").font(.headline)
            Spacer()
            Text("SET \(setNumber)").font(.headline)
        }
        .padding()
        .background(.white.opacity(0.8))
    }

    var bottomBar: some View {
        if gameOver {
            return AnyView(
                Text("\(winnerColor == .blue ? "Blue" : "Red") Wins!")
                    .font(.title)
                    .foregroundColor(winnerColor ?? .black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.bottom, 8)
            )
        } else {
            return AnyView(
                Text("Tap team area to score")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.bottom, 8)
            )
        }
    }
}

#Preview {
    ScoreboardView(matchState: MatchState())
}

