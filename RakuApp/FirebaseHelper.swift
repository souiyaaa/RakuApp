//
//  FirebaseHelper.swift
//  RakuApp
//
//  Created by student on 04/06/25.
//

import Foundation
import FirebaseDatabase

class FirebaseHelper {
    static let shared = FirebaseHelper()
    private let ref = Database.database().reference()

    private init() {}

    func saveMatch(id: String, matchData: [String: Any], completion: @escaping (Error?) -> Void) {
        ref.child("matches").child(id).setValue(matchData) { error, _ in
            completion(error)
        }
    }

    func saveMatchScore(matchID: String, scoreData: [String: Any], completion: @escaping (Error?) -> Void) {
        ref.child("matches").child(matchID).child("score").setValue(scoreData) { error, _ in
            completion(error)
        }
    }
}
