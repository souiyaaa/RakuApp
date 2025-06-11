import SwiftUI
import FirebaseAuth
import SwiftData

struct MatchDetailView: View {
    @ObservedObject var matchState: MatchState
    @State private var currentTime: String = ""
    @State private var selectedMatch: CurrentMatch? = nil
    @State private var navigateToScoreboard = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.modelContext) private var context
    @State private var matches: [CurrentMatch] = []

    init(matchState: MatchState) {
        self.matchState = matchState
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("QUICK")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.5))
                        Text("MATCH")
                            .font(.title2)
                            .italic()
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .red.opacity(0.2), .orange.opacity(0.2), .yellow.opacity(0.2),
                                .green.opacity(0.2), .blue.opacity(0.2), .purple.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What do you want to do?")
                            .font(.headline)
                        HStack(spacing: 16) {
                            ActionButtonView(color: .green, icon: "sportscourt", label: "Be Referee")
                            NavigationLink(destination: SinglesView(matchState: matchState)) {
                                ActionButtonView(color: .blue, icon: "person", label: "Singles")
                            }
                            NavigationLink(destination: DoublesView(matchState: matchState)) {
                                ActionButtonView(color: .orange, icon: "person.2", label: "Doubles")
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Match History")
                            .font(.headline)

                        ForEach(matches) { match in
                            Button {
                                selectedMatch = match
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    navigateToScoreboard = true
                                }
                            } label: {
                                MatchCardView(match: match, currentTime: currentTime)
                            }
                        }

                        NavigationLink(
                            isActive: $navigateToScoreboard,
                            destination: {
                                Group {
                                    if let match = selectedMatch {
                                        ScoreboardView(matchState: MatchState(currentMatch: match))
                                    } else {
                                        EmptyView()
                                    }
                                }
                            },
                            label: {
                                EmptyView()
                            }
                        )
                        .hidden()
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Current Match")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadMatches()
            }
            .onReceive(timer) { _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                currentTime = formatter.string(from: Date())
            }
        }
    }

    func loadMatches() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No user logged in")
            return
        }
        let descriptor = FetchDescriptor<CurrentMatch>(
            predicate: #Predicate { $0.userID == uid },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        do {
            matches = try context.fetch(descriptor)
        } catch {
            print("❌ Failed to fetch matches: \(error.localizedDescription)")
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

struct MatchCardView: View {
    let match: CurrentMatch
    let currentTime: String

    var body: some View {
        HStack {
            if match.playerNames.count == 2 {
                Text(match.playerNames[0])
                    .font(.caption)
                    .foregroundColor(.white)

                Spacer()

                Text("\(match.blueScore)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.white)

                Spacer()

                Text("\(match.redScore)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                Text(match.playerNames[1])
                    .font(.caption)
                    .foregroundColor(.white)

            } else {
                VStack(alignment: .leading) {
                    ForEach(match.playerNames.prefix(2), id: \.self) { name in
                        Text(name)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                Text("\(match.blueScore)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.white)

                Spacer()

                Text("\(match.redScore)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                VStack(alignment: .trailing) {
                    ForEach(match.playerNames.dropFirst(2), id: \.self) { name in
                        Text(name)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 0.0, green: 0.2, blue: 0.5))
        .cornerRadius(12)
    }
}

#Preview {
    let container = try! ModelContainer(for: CurrentMatch.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return MatchDetailView(matchState: MatchState())
        .modelContainer(container)
}

