//
//  MatchViewModel.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import Foundation
import CoreLocation
import SwiftUI

class MatchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Match Data
    @Published var match: Match
    var currentGame: Game? {
        match.games.last
    }
    var participantCount: Int {
        match.players.count
    }
    
    // MARK: - Location Properties
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    @Published var userLocationDescription: String = "Fetching location..."
    
    // MARK: - Init
    init(match: Match) {
        self.match = match
        super.init()
        configureLocationServices()
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Manual Location Refresh
    func refreshLocation() {
        print("🔄 Refreshing location...")
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("📍 Received location update: \(locations)")
        guard let location = locations.last else { return }
        reverseGeocode(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
        userLocationDescription = "Unable to get address"
    }
    
    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("🧭 Geocoding error: \(error.localizedDescription)")
                self?.userLocationDescription = "Unable to get address"
                return
            }
            
            if let placemark = placemarks?.first {
                let place = [
                    placemark.name,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                self?.userLocationDescription = place
            }
        }
    }
}
