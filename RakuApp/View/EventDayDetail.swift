//
//  EventDayDetail.swift
//  RakuApp
//
//  Created by student on 05/06/25.
//

import SwiftUI

struct EventInvitationView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var userViewModel: UserViewModel // Needed to check current user's ID

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Iterate through matches fetched by gameViewModel
                ForEach(gameViewModel.matches) { match in
                    EventRowView(match: match, currentUser: userViewModel.myUserData)
                }
            }
            .padding()
        }
    }
}

struct EventRowView: View {
    let match: Match // Pass the entire match object
    let currentUser: MyUser // Pass the current user for invitation check
    @EnvironmentObject var gameViewModel: GameViewModel

    @State private var showingSplitPayment = false
    @State private var showingEditEvent = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Time bubble (You might want to format match.date for this)
            Text(match.date, formatter: timeFormatter)
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray5))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                let isInvited = match.players.contains(where: { $0.id == currentUser.id })

                if isInvited {
                    // Big invite card
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.pink, .orange, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 100)

                        Text("YOU ARE\nINVITED")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()

                        // Check if the current user has paid for this match
                        if match.paidUserIds.contains(currentUser.id ?? "") { // Assuming currentUser.id is not nil
                            Label("Going", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(6)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .offset(x: -10, y: 10)
                        }
                    }
                }

                // Title and location
                VStack(alignment: .leading, spacing: 2) {
                    Text(match.name)
                        .fontWeight(.semibold)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(match.location)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }

                // Participants
                HStack(spacing: 6) {
                    HStack(spacing: -10) {
                        ForEach(match.players.prefix(3), id: \.id) { _ in // Display up to 3 participant icons
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }

                    Text("\(match.players.count) Participants")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Buttons
                if isInvited {
                    HStack(spacing: 10) {
                        Button("Get Direction") {
                            // Action for Get Direction
                            // You might want to integrate MapKit here
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Payments info") {
                            gameViewModel.setCurrentMatch(matchId: match.id) // Set the current match before navigating
                            showingSplitPayment = true
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .sheet(isPresented: $showingSplitPayment) {
                            SplitPayment()
                                .environmentObject(gameViewModel) // Pass environment object to the sheet
//                                .environmentObject(userViewModel)
                        }

                        Button("Edit Event") {
                            gameViewModel.setCurrentMatch(matchId: match.id) // Set the current match before navigating
                            showingEditEvent = true
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .sheet(isPresented: $showingEditEvent) {
                            EditEventView()
                                .environmentObject(gameViewModel) // Pass environment object to the sheet
                        }
                    }
                }

                Divider()
            }
        }
    }

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

//#Preview{
//    // Mock user for preview
//    let mockUser = MyUser(
//        id: "mockUser123",
//        name: "Preview User",
//        email: "preview@example.com",
//        password: "password",
//        experience: "Beginner"
//    )
//
//    // UserViewModel setup for preview
//    let userViewModel = UserViewModel()
//    userViewModel.myUserData = mockUser
//
//    // Mock matches for preview
//    let mockMatch1 = Match(
//        id: UUID().uuidString,
//        name: "Junior Badminton Tournament",
//        description: "A competitive tournament for junior players.",
//        date: Date(), // Current time for now
//        courtCost: 100.0,
//        players: [mockUser], // User is invited
//        games: [],
//        paidUserIds: [],
//        location: "Weston Citraland"
//    )
//
//    let mockMatch2 = Match(
//        id: UUID().uuidString,
//        name: "Evening Friendly Match",
//        description: "Casual game with friends.",
//        date: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!, // Future time
//        courtCost: 50.0,
//        players: [], // User is not invited
//        games: [],
//        paidUserIds: [],
//        location: "Galaxy Sports Center"
//    )
//
//    // GameViewModel setup for preview
//    let gameViewModel = GameViewModel(userViewModel: userViewModel)
//    gameViewModel.matches = [mockMatch1, mockMatch2]
//
//    return EventInvitationView()
//        .environmentObject(gameViewModel)
//        .environmentObject(userViewModel)
//}
