// souiyaaa/rakuapp/RakuApp-b4efc2de3e01e479eee184089dffb9fa47c7af7d/RakuApp/View/MatchView.swift

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var gameVM: GameViewModel
    @EnvironmentObject var matchVM: MatchViewModel

    @StateObject private var calendarVM = CalendarViewModel()
    @State var isAddEvent = false

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
                // User info row...
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
                        HStack{
                            Text(
                                "\(authVM.userViewModel.myUserData.name.isEmpty ? "User" : authVM.userViewModel.myUserData.name) you are at"
                            )
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack{
                            Text(matchVM.userLocationDescription)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
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

                // Current match ScoreCard...
                HStack{
                    Text("Current match")
                    Spacer()
                    Button("More"){
                    }
                    .foregroundColor(Color(hex: "253366"))
                    .font(.headline)
                }
                .padding(.horizontal, 20)
                ScoreCard()

                // Events section...
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
                
                // REMOVED: The entire "Quick Match" button block is now gone from here.
                
                Spacer() // Add a spacer to push content up if the list is short
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isAddEvent) {
                NavigationStack {
                    AddNewEventView(isAddEvent: $isAddEvent)
                }
            }
        }
        .onChange(of: authVM.userViewModel.myUserData.id) { newUserId in
            if !newUserId.isEmpty {
                gameVM.fetchMatches()
            }
        }
    }
}
