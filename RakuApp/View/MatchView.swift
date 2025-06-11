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
        guard let selectedDate = calendarVM.selectedDay else { return [] }
        return gameVM.matches.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // User Info Section
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
                            Text("\(authVM.userViewModel.myUserData.name.isEmpty ? "User" : authVM.userViewModel.myUserData.name) you are at")
                                .font(.body)
                            Text(matchVM.userLocationDescription)
                                .font(.headline)
                            Button {
                                matchVM.refreshLocation()
                            } label: {
                                Label("Refresh Location", systemImage: "arrow.clockwise.circle")
                            }
                        }
                        .padding(.horizontal, 4)

                        Spacer()

                        Button("Logout") {
                            authVM.signOut()
                        }
                        .foregroundColor(.red)
                    }
                    .padding()

                    // Current Match Section
                    HStack {
                        Text("Current match")
                        Spacer()
                        NavigationLink(
                            destination: MatchDetailView(matchState: matchState)
                                .environment(\.modelContext, context)
                        ) {
                            Text("More")
                                .foregroundColor(Color(hex: "253366"))
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal)

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
                    .padding(.horizontal)
                    .padding(.top, 12)

                    CalendarView(viewModel: calendarVM)

                    EventInvitationView(matches: filteredMatches, currentUser: authVM.userViewModel.myUserData)

                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isAddEvent) {
                NavigationStack {
                    AddNewEventView(isAddEvent: $isAddEvent)
                }
            }
            .onAppear {
                gameVM.fetchMatches(for: calendarVM.selectedDay ?? Date())
                loadLatestMatch()
            }
            .onChange(of: calendarVM.selectedDay) { date in
                if let date = date {
                    gameVM.fetchMatches(for: date)
                }
            }
//            .onChange(of: authVM.userViewModel.myUserData.id) { newUserId in
//                if !newUserId.isEmpty {
//                    gameVM.fetchMatches()
//                    loadLatestMatch()
//                }
//            }
            .onReceive(timer) { _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                currentTime = formatter.string(from: Date())
            }
        }
    }

    func loadLatestMatch() {
        let uid = authVM.userViewModel.myUserData.id
        guard !uid.isEmpty else {
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
