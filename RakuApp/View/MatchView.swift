// souiyaaa/rakuapp/RakuApp-b4efc2de3e01e479eee184089dffb9fa47c7af7d/RakuApp/View/MatchView.swift

import SwiftUI
import SwiftData

struct MatchView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var gameVM: GameViewModel
    @EnvironmentObject var matchVM: MatchViewModel
    @Environment(\.modelContext) private var context

    @StateObject private var calendarVM = CalendarViewModel()
    @StateObject private var matchState = MatchState()
    @State var isAddEvent = false

    @State private var latestMatch: CurrentMatch? = nil
    @State private var currentTime: String = ""
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var filteredMatches: [Match] {
        guard let selectedDate = calendarVM.selectedDay else {
            return []
        }
        return gameVM.matches.filter { match in
            Calendar.current.isDate(match.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // User info row
                HStack {
                    if let uiImage = authVM.userViewModel.myUserPicture {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(authVM.userViewModel.myUserData.name.isEmpty ? "User" : authVM.userViewModel.myUserData.name) you are at")
                                .font(.body)
                            Spacer()
                        }
                        HStack {
                            Text(matchVM.userLocationDescription)
                                .font(.headline)
                            Spacer()
                        }
                        Button(action: {
                            matchVM.refreshLocation()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise.circle")
                                Text("Refresh Location")
                            }
                        }
                    }
                    .padding(.horizontal, 4)

                    Button("Logout") {
                        authVM.signOut()
                    }
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                }
                .padding()

                // Current Match Section
                HStack {
                    Text("Current match")
                    Spacer()
                    Button("More") {}
                        .foregroundColor(Color(hex: "253366"))
                        .font(.headline)
                }
                .padding(.horizontal, 20)

                if let match = latestMatch {
                    MatchCardView(match: match, currentTime: currentTime)
                        .padding(.horizontal)
                } else {
                    Text("No current match")
                        .foregroundColor(.gray)
                        .padding()
                }

                // Events Section
                HStack {
                    Text("Events")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 4)

                CalendarView(viewModel: calendarVM)

                EventInvitationView(matches: filteredMatches, currentUser: authVM.userViewModel.myUserData)

                Spacer()

                // Quick Match Button
                HStack {
                    Spacer()
                    NavigationLink(
                        destination:
                            MatchDetailView(matchState: matchState)
                            .environment(\.modelContext, context)
                    ) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Quick Match")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.vertical, 10)

                Spacer()
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isAddEvent) {
                NavigationStack {
                    AddNewEventView(isAddEvent: $isAddEvent)
                }
            }
            .onChange(of: authVM.userViewModel.myUserData.id) { newUserId in
                if !newUserId.isEmpty {
                    gameVM.fetchMatches()
                    loadLatestMatch()
                }
            }
            .task {
                loadLatestMatch()
            }
            .onReceive(timer) { _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                currentTime = formatter.string(from: Date())
            }

            .onChange(of: authVM.userViewModel.myUserData.id) { newUserId in
                if !newUserId.isEmpty {
                    gameVM.fetchMatches()
                    loadLatestMatch()
                }
            }
        }
    }

    func loadLatestMatch() {
        let uid = authVM.userViewModel.myUserData.id
        if uid.isEmpty {
            print("❌ No user logged in")
            return
        }

        let descriptor = FetchDescriptor<CurrentMatch>(
            predicate: #Predicate { $0.userID == uid },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        do {
            let fetchedMatches = try context.fetch(descriptor)
            latestMatch = fetchedMatches.first
        } catch {
            print("❌ Failed to fetch latest match: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: CurrentMatch.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return MatchView()
        .environmentObject(AuthViewModel(userViewModel: UserViewModel()))
        .environmentObject(GameViewModel(userViewModel: UserViewModel()))
        .environmentObject(MatchViewModel())
        .environmentObject(ActivityViewModel(authViewModel: AuthViewModel(userViewModel: UserViewModel())))
        .environmentObject(GripViewModel())
        .modelContainer(container)
}
