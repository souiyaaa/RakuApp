//
//  SplitPayment.swift
//  RakuApp
//
//  Created by student on 05/06/25.
//

import SwiftUI

struct SplitPayment: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var userViewModel: UserViewModel // To get all users for participant list

    @State private var selectedUsers: Set<String> = [] // Changed to use user IDs for selection

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cost Per Pack")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(gameViewModel.currentMatch?.courtCost != nil ? "Rp\(Int(gameViewModel.currentMatch!.courtCost))" : "N/A")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Ask the event organizers for bank info")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()

                List {
                    ForEach(gameViewModel.currentMatch?.players ?? [], id: \.id) { participant in
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)

                            VStack(alignment: .leading) {
                                Text(participant.name)
                                    .fontWeight(.medium)
                                Text(participant.email) // Using email as a placeholder for location/detail
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            if gameViewModel.currentMatch?.paidUserIds.contains(participant.id ?? "") ?? false {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if selectedUsers.contains(participant.id ?? "") { // Check if selected in current session
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let userId = participant.id {
                                if selectedUsers.contains(userId) {
                                    selectedUsers.remove(userId)
                                } else {
                                    selectedUsers.insert(userId)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    // Save action - mark selected users as paid in Firebase
                    if let matchId = gameViewModel.currentMatch?.id {
                        for userId in selectedUsers {
                            gameViewModel.markPlayerAsPaid(matchId: matchId, userId: userId)
                        }
                    }
                }) {
                    Text("Save Update")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Payment Info")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Initialize selectedUsers based on already paid users from the current match
            if let paidUserIds = gameViewModel.currentMatch?.paidUserIds {
                selectedUsers = Set(paidUserIds)
            }
        }
    }
}

#Preview {
    // Mock data for preview
    let mockUser = MyUser(id: "user1", name: "Alice", email: "alice@example.com", password: "p", experience: "Beginner")
    let mockUser2 = MyUser(id: "user2", name: "Bob", email: "bob@example.com", password: "p", experience: "Advance")
    let mockUser3 = MyUser(id: "user3", name: "Charlie", email: "charlie@example.com", password: "p", experience: "Pro")

    let userViewModel = UserViewModel()
    userViewModel.myUserData = mockUser // Set current user for context

    let mockMatch = Match(
        id: "match1",
        name: "Preview Match",
        description: "Description",
        date: Date(),
        courtCost: 120000.0,
        players: [mockUser, mockUser2, mockUser3],
        games: [],
        paidUserIds: ["user1"], // Alice has already paid
        location: "Preview Location"
    )

    let gameViewModel = GameViewModel(userViewModel: userViewModel)
    gameViewModel.currentMatch = mockMatch // Set the current match for the preview

    return SplitPayment()
        .environmentObject(gameViewModel)
        .environmentObject(userViewModel)
}
