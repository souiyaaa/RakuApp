//
//  MatchDetailViewModel.swift
//  RakuApp
//
//  Created by student on 05/06/25.
//

import Foundation
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class MatchDetailViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var matches: [MatchDetailModel] = []
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var userLocationDescription: String = "Fetching location..."

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startMatch(players: [String], bestOf: Int, gameUpTo: Int, maxScore: Int) {
        let match = MatchDetailModel(players: players, bestOf: bestOf, gameUpTo: gameUpTo, maxScore: maxScore)
        self.matches.insert(match, at: 0)
    }

    func updateScores(matchID: UUID, blue: Int, red: Int) {
        if let index = matches.firstIndex(where: { $0.id == matchID }) {
            matches[index].blueScore = blue
            matches[index].redScore = red
        }
    }

    func refreshLocation() {
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        reverseGeocode(location: location)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        userLocationDescription = "Unable to get address"
    }

    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                let place = [
                    placemark.name,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                self?.userLocationDescription = place
            } else {
                self?.userLocationDescription = "Unable to get address"
            }
        }
    }
    
    func saveMatchToFirebase(match: MatchDetailModel) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("❌ No authenticated user.")
            return
        }

        let ref = Database.database().reference()
        let matchID = match.id.uuidString

        let matchData: [String: Any] = [
            "startTime": ISO8601DateFormatter().string(from: match.startTime),
            "players": match.players,
            "bestOf": match.bestOf,
            "gameUpTo": match.gameUpTo,
            "maxScore": match.maxScore,
            "blueScore": match.blueScore,
            "redScore": match.redScore,
            "isFinished": match.isFinished
        ]

        ref.child("users").child(userID).child("matches").child(matchID).setValue(matchData) { error, _ in
            if let error = error {
                print("❌ Error saving match: \(error.localizedDescription)")
            } else {
                print("✅ Match saved successfully to Firebase.")
            }
        }
    }

}
