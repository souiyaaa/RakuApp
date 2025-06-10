// souiyaaa/rakuapp/RakuApp-b4efc2de3e01e479eee184089dffb9fa47c7af7d/RakuApp/ViewModel/GameViewModel.swift

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
        // FIX: DO NOT fetch matches here. The user is not yet loaded.
        // fetchMatches()
    }

    func fetchMatches() {
        let currentUserId = userViewModel.myUserData.id
        
        // FIX: Add a guard to prevent fetching if the user ID is not yet available.
        guard !currentUserId.isEmpty else {
            print("User ID not available yet. Skipping match fetch.")
            return
        }
        
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
    
    // The rest of your GameViewModel code remains the same...
    // addMatch, updateMatch, etc. are all correct.
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
        var finalPlayers = players
        let currentUser = self.userViewModel.myUserData
        if !finalPlayers.contains(where: { $0.id == currentUser.id }) {
            finalPlayers.append(currentUser)
        }

        let newMatch = Match(
            name: name,
            description: description,
            date: date,
            courtCost: courtCost,
            players: finalPlayers,
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
        
        DispatchQueue.main.async {
            self.matches.append(newMatch)
        }
        
        print(newMatch)
        print("function is done ")
        return true
    }

    func updateMatch(_ match: Match) {
            guard let jsonData = try? JSONEncoder().encode(match),
                let json = try? JSONSerialization.jsonObject(with: jsonData)
                    as? [String: Any]
            else {
                return
            }
            
            ref.child(match.id).setValue(json)

            DispatchQueue.main.async {
                if let index = self.matches.firstIndex(where: { $0.id == match.id }) {
                    self.matches[index] = match
                    print("Local match array updated for match ID: \(match.id)")
                }
                
                if self.currentMatch?.id == match.id {
                    self.currentMatch = match
                    print("Current match state updated.")
                }
            }
        }

    func deleteMatch(_ match: Match) {
        ref.child(match.id).removeValue()
    }

    func markPlayerAsPaid(matchId: String, userId: String) {
          guard let matchIndex = matches.firstIndex(where: { $0.id == matchId }) else {
              print("Error: Could not find match with ID \(matchId)")
              return
          }
          
          if var currentMatch = self.currentMatch, currentMatch.id == matchId {
              if let paidIndex = currentMatch.paidUserIds.firstIndex(of: userId) {
                  currentMatch.paidUserIds.remove(at: paidIndex)
              } else {
                  currentMatch.paidUserIds.append(userId)
              }
              self.currentMatch = currentMatch
          }

          if let paidIndexInMatches = matches[matchIndex].paidUserIds.firstIndex(of: userId) {
              matches[matchIndex].paidUserIds.remove(at: paidIndexInMatches)
          } else {
              matches[matchIndex].paidUserIds.append(userId)
          }
          
          updateMatch(matches[matchIndex])
      }
}
