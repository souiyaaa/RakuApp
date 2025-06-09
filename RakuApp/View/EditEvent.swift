//
//  EditEvent.swift
//  RakuApp
//
//  Created by student on 05/06/25.
//

import SwiftUI

struct EditEventView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss // To close the sheet

    @State private var selectedDate = Date() // Use Date for date picker
    @State private var time: String = "" // Will be populated from match date
    @State private var cost: String = ""
    @State private var eventName: String = ""
    @State private var description: String = ""
    @State private var level: String = "" // Assuming this corresponds to 'experience' or a game-specific level

    @State private var showingAddPlayers = false

    // Formatter for displaying time
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm WIB"
        return formatter
    }()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Reschedule section (simplified with DatePicker)
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(.bottom, 10)

                    // Participants (displaying actual participant count and button to add more)
                    HStack {
                        HStack(spacing: -10) {
                            ForEach(gameViewModel.currentMatch?.players.prefix(3) ?? [], id: \.id) { _ in
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }

                        Text("\(gameViewModel.currentMatch?.players.count ?? 0) Participants")
                            .font(.subheadline)

                        Spacer()

                        Button("Add/Remove Players") {
                            showingAddPlayers = true
                        }
                        .font(.subheadline)
                        .sheet(isPresented: $showingAddPlayers) {
                            // You'll need a new view for adding/removing players
                            // This would typically involve fetching all users and allowing selection
                            // For simplicity, we'll just have a placeholder here.
                            AddPlayersView(matchId: gameViewModel.currentMatch?.id ?? "")
                                .environmentObject(gameViewModel)
                                .environmentObject(gameViewModel.userViewModel) // Pass userViewModel to AddPlayersView
                        }
                    }

                    // Fields
                    Group {
                        TextField("Time (e.g., 09:13 WIB)", text: $time)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: selectedDate) { newDate in
                                time = timeFormatter.string(from: newDate)
                            }

                        TextField("Cost of Court", text: $cost)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Name Your Event", text: $eventName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Description", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Game Level", text: $level)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    Button(action: {
                        // Save update action
                        if var match = gameViewModel.currentMatch {
                            match.name = eventName
                            match.description = description
                            // Convert cost string to Double
                            if let newCost = Double(cost) {
                                match.courtCost = newCost
                            }
                            match.date = selectedDate // Update date
                            // Assuming 'level' might be part of the match or a game
                            // For now, it's a simple text field.
                            gameViewModel.updateMatch(match)
                            dismiss() // Close the sheet
                        }
                    }) {
                        Text("Save Update")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Populate fields when the view appears
                if let match = gameViewModel.currentMatch {
                    eventName = match.name
                    description = match.description
                    cost = String(format: "%.0f", match.courtCost) // Format to whole number if applicable
                    selectedDate = match.date
                    time = timeFormatter.string(from: match.date)
                    // You might need to add a 'level' property to your Match model
                    // For now, it remains empty or you can set a default.
                }
            }
        }
    }
}

// Placeholder for AddPlayersView
struct AddPlayersView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var gameViewModel: GameViewModel
    let matchId: String

    @State private var searchText = ""
    @State private var selectedPlayers: Set<String> = []

    var filteredUsers: [MyUser] {
        if searchText.isEmpty {
            return userViewModel.myUserDatas
        } else {
            return userViewModel.filterUserByName(byName: searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search Players")

                List {
                    ForEach(filteredUsers) { user in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text(user.name)
                                Text(user.experience)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if selectedPlayers.contains(user.id ?? "") {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onTapGesture {
//                            if let id = user.id {
//                                if selectedPlayers.contains(id) {
//                                    selectedPlayers.remove(id)
//                                } else {
//                                    selectedPlayers.insert(id)
//                                }
//                            }
                        }
                    }
                }
                Button("Add Selected Players") {
                    let playersToAdd = userViewModel.myUserDatas.filter { selectedPlayers.contains($0.id ?? "") }
                    _ = gameViewModel.addPlayersToMatch(matchId, playersToAdd)
                    // Potentially dismiss this view
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Players")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Pre-select players already in the match
            if let currentMatchPlayers = gameViewModel.currentMatch?.players {
                selectedPlayers = Set(currentMatchPlayers.compactMap { $0.id })
            }
        }
    }
}

// Simple SearchBar for AddPlayersView
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    // Mock data for preview
//    let mockUser = MyUser(id: "user1", name: "Alice", email: "alice@example.com", password: "p", experience: "Beginner")
//    let userViewModel = UserViewModel()
//    userViewModel.myUserData = mockUser
//
//    let mockMatch = Match(
//        id: "match1",
//        name: "Badminton Session",
//        description: "Casual game at the community hall.",
//        date: Date(),
//        courtCost: 80000.0,
//        players: [mockUser],
//        games: [],
//        paidUserIds: [],
//        location: "Community Hall"
//    )
//
//    let gameViewModel = GameViewModel(userViewModel: userViewModel)
//    gameViewModel.currentMatch = mockMatch
//
//    return EditEventView()
//        .environmentObject(gameViewModel)
//        .environmentObject(userViewModel) // Also pass userViewModel for AddPlayersView in preview
//}
