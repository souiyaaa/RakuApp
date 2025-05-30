//
//  ActivityViewModel.swift
//  RakuApp
//
//  Created by student on 30/05/25.
//
import Foundation
import WatchConnectivity

class ActivityViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var activity = ActivityModel(
        id: 1,
        TotalEnergyBurned: 124,
        ExerciseTime: 50,
        TotalStandingTime: 80,
        TotalGame: 8
    )

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendActivityToWatch() {
        if WCSession.default.isReachable {
            let data: [String: Any] = [
                "TotalEnergyBurned": activity.TotalEnergyBurned,
                "ExerciseTime": activity.ExerciseTime,
                "TotalStandingTime": activity.TotalStandingTime,
                "TotalGame": activity.TotalGame
            ]

            WCSession.default.sendMessage(data, replyHandler: nil) { error in
                print("Error sending message to watch: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable")
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation if needed
        print("iOS WCSession activated: \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
}
