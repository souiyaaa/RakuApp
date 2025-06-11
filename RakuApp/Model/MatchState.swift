import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftData

class MatchState: ObservableObject {
    @Published var selectedUsers: [MyUser] = []
    @Published var blueScore: Int = 0
    @Published var redScore: Int = 0
    @Published var matchType: MatchType = .single
    @Published var hasStarted = false
    @Published var gameUpTo: Int = 21
    @Published var maxScore: Int = 30
    @Published var currentMatch: CurrentMatch? = nil  // ✅ 현재 SwiftData match

    private var ref: DatabaseReference = Database.database().reference().child("Matches")

    // MARK: - 초기화
    init() {}

    init(currentMatch: CurrentMatch) {
        self.currentMatch = currentMatch
        self.blueScore = currentMatch.blueScore
        self.redScore = currentMatch.redScore
        self.matchType = MatchType(rawValue: currentMatch.matchType) ?? .single
        self.selectedUsers = currentMatch.playerNames.map { MyUser(name: $0) }
        self.gameUpTo = currentMatch.gameUpTo
        self.maxScore = currentMatch.maxScore
        self.hasStarted = true
    }

    // MARK: - Firebase 저장
    func saveCurrentMatchToFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let setting = MatchSetting(
            gameUpTo: gameUpTo,
            maxScore: maxScore,
            matchType: matchType.rawValue,
            blueScore: blueScore,
            redScore: redScore,
            playerNames: selectedUsers.map { $0.name }
        )

        do {
            let jsonData = try JSONEncoder().encode(setting)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            guard let matchDict = jsonObject as? [String: Any] else { return }

            ref.child(uid).setValue(matchDict) { error, _ in
                if let error = error {
                    print("❌ Firebase save error: \(error.localizedDescription)")
                } else {
                    print("✅ Firebase saved successfully.")
                }
            }
        } catch {
            print("❌ JSON encode error: \(error.localizedDescription)")
        }
    }

    // MARK: - SwiftData에 저장 (신규 Match 기록용)
    func saveToLocalMatchHistory(context: ModelContext) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let localMatch = CurrentMatch(
            userID: uid,
            matchType: matchType.rawValue,
            playerNames: selectedUsers.map { $0.name },
            gameUpTo: gameUpTo,
            maxScore: maxScore,
            blueScore: blueScore,
            redScore: redScore,
            timestamp: Date()
        )

        context.insert(localMatch)
        do {
            try context.save()
            print("✅ Local match saved.")
        } catch {
            print("❌ Local save error: \(error.localizedDescription)")
        }
    }

    // MARK: - SwiftData에 점수 저장 (진행 중 Match 업데이트용)
    func saveScoreToLocal(context: ModelContext) {
        guard let currentMatch = self.currentMatch else { return }

        currentMatch.blueScore = blueScore
        currentMatch.redScore = redScore

        do {
            try context.save()
            print("✅ Score updated locally.")
        } catch {
            print("❌ Failed to update local score: \(error.localizedDescription)")
        }
    }
    
    func saveCurrentMatch(gameUpTo: Int, maxScore: Int) {
        self.gameUpTo = gameUpTo
        self.maxScore = maxScore
        self.hasStarted = true
    }
    
}

// Codable 구조체
struct MatchSetting: Codable {
    var gameUpTo: Int
    var maxScore: Int
    var matchType: String
    var blueScore: Int
    var redScore: Int
    var playerNames: [String]
}

// 싱글/더블 타입
enum MatchType: String, Codable {
    case single
    case doubles
}

