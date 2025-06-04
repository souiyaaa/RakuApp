//
//  GameViewModel.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import FirebaseDatabase
import Foundation

class GameViewModel: ObservableObject {
    @Published var matches = [Match]()
    private var ref: DatabaseReference
    @Published var userViewModel: UserViewModel
    @Published var currentMatch: Match?

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        self.ref = Database.database().reference().child("matches")
        fetchMatches()
    }

    func fetchMatches() {
        let currentUserId = userViewModel.myUserData.id
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                self.matches = []
                return
            }

            let filteredMatches = value.compactMap {
                (key, matchData) -> Match? in
                guard let matchDict = matchData as? [String: Any],
                    let jsonData = try? JSONSerialization.data(
                        withJSONObject: matchDict),
                    let match = try? JSONDecoder().decode(
                        Match.self, from: jsonData)
                else {
                    return nil
                }

                let playerIds = match.players.map { $0.id }
                if playerIds.contains(currentUserId) {
                    return match
                } else {
                    return nil
                }
            }

            DispatchQueue.main.async {
                self.matches = filteredMatches
            }
        }
    }
    
    func setCurrentMatch(matchId: String) {
        if let match = matches.first(where: { $0.id == matchId }) {
            DispatchQueue.main.async {
                self.currentMatch = match
            }
        } else {
            print(" Match with ID \(matchId) not found.")
        }
    }
    
    func addPlayersToMatch(_ matchId: String, _ players: [MyUser]) -> Bool {
        guard let index = matches.firstIndex(where: { $0.id == matchId }) else {
            return false
        }
        
        var updatedMatch = matches[index]
        
        // Avoid adding duplicates
        for player in players {
            if !updatedMatch.players.contains(where: { $0.id == player.id }) {
                updatedMatch.players.append(player)
            }
        }
        
        updateMatch(updatedMatch)
        return true
    }
    

    func addMatch(
        name: String, description: String, date: Date, courtCost: Double,
        players: [MyUser], location: String
    ) -> Bool {
        let newMatch = Match(
            name: name,
            description: description,
            date: date,
            courtCost: courtCost,
            players: players,
            games: [],
            paidUserIds: [],
            location: location
        )

        guard let jsonData = try? JSONEncoder().encode(newMatch),
            let json = try? JSONSerialization.jsonObject(with: jsonData)
                as? [String: Any]
        else {
            print("function failed to add match")
           
            return false
           
        }

        ref.child(newMatch.id).setValue(json)
        print(newMatch)
        print("function is done ")
        return true
       
    }

    func addGame(to matchId: String, game: Game) {
        guard let index = matches.firstIndex(where: { $0.id == matchId }) else {
            return
        }
        matches[index].games.append(game)
        updateMatch(matches[index])
    }

    func updateMatch(_ match: Match) {
        guard let jsonData = try? JSONEncoder().encode(match),
            let json = try? JSONSerialization.jsonObject(with: jsonData)
                as? [String: Any]
        else {
            return
        }
        ref.child(match.id).setValue(json)
    }

    func deleteMatch(_ match: Match) {
        ref.child(match.id).removeValue()
    }

    func markPlayerAsPaid(matchId: String, userId: String) {
        guard let index = matches.firstIndex(where: { $0.id == matchId }) else {
            return
        }
        if !matches[index].paidUserIds.contains(userId) {
            matches[index].paidUserIds.append(userId)
            updateMatch(matches[index])
        }
    }

}
