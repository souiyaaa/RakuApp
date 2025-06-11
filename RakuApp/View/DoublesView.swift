import SwiftUI
import SwiftData

struct DoublesView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var gameUpTo = 21
    @State private var maxScore = 30
    @State private var showFriendPicker = false
    @StateObject private var userVM = UserViewModel()
    @ObservedObject var matchState: MatchState

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Choose Friends") {
                    showFriendPicker = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .sheet(isPresented: $showFriendPicker) {
                    NavigationView {
                        MatchFriendView(
                            userVM: userVM,
                            selectedUsers: $matchState.selectedUsers,
                            maxSelection: 4
                        )
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Participants").font(.headline)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)) {
                        ForEach(matchState.selectedUsers.prefix(4), id: \ .id) { user in
                            PlayerView(name: user.name)
                        }
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 10) {
                    SingleSettingRow(title: "Game up to", value: $gameUpTo, highlighted: true)
                    SingleSettingRow(title: "Max Score", value: $maxScore)
                }
                .padding(.horizontal)

                Button("Start Match") {
                    matchState.matchType = .doubles
                    matchState.blueScore = 0
                    matchState.redScore = 0
                    matchState.saveCurrentMatch(gameUpTo: gameUpTo, maxScore: maxScore)
                    matchState.saveToLocalMatchHistory(context: context)
                    dismiss()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding()
            .onAppear {
                matchState.selectedUsers = []
            }
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
