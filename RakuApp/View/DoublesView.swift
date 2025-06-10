import SwiftUI

struct DoublesView: View {
    @State private var bestOf = 3
    @State private var gameUpTo = 21
    @State private var maxScore = 30

    @State private var startMatch = false
    @ObservedObject var matchState: MatchState

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    ForEach(0..<2) { _ in
                        HStack(spacing: 20) {
                            ForEach(0..<2) { _ in
                                PlayerView(name: "Player")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Participants").font(.headline)
                    HStack(spacing: 20) {
                        TeamBox(title1: "Team 1 left", title2: "Team 1 Right", color: Color.blue.opacity(0.1))
                        TeamBox(title1: "Team 2 left", title2: "Team 2 Right", color: Color.red.opacity(0.1))
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 10) {
                    SettingControlRow(title: "Best of", value: $bestOf)
                    SettingControlRow(title: "Game up to", value: $gameUpTo, highlighted: true)
                    SettingControlRow(title: "Max Score", value: $maxScore)
                }
                .padding(.horizontal)

                Button("Random Match Detail") {}
                    .foregroundColor(.blue)

                Button("Start Match") {
                    matchState.matchType = .doubles
                    startMatch = true
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)

                NavigationLink(destination: ScoreboardView(matchState: matchState), isActive: $startMatch) {
                    EmptyView()
                }
            }
            .padding(.vertical)
        }
    }
}

struct PlayerView: View {
    var name: String
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable().frame(width: 40, height: 40)
            Text(name).font(.body)
        }
        .frame(width: 140, height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TeamBox: View {
    let title1: String
    let title2: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            HStack { Text(title1); Spacer(); Image(systemName: "xmark.circle") }
                .padding(8).background(color).cornerRadius(8)
            HStack { Text(title2); Spacer(); Image(systemName: "xmark.circle") }
                .padding(8).background(color).cornerRadius(8)
        }
        .frame(width: 150)
    }
}

struct SettingControlRow: View {
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
    DoublesView(matchState: MatchState())
}
