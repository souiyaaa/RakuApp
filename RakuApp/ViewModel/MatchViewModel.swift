//
//  MatchViewModel.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import Foundation
import CoreLocation
class MatchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var userLocationDescription: String = "Fetching location..."
    
    override init() {
        super.init()
        print("Init masuk 1")
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print("Init abis 1")
    }
    
    // 👇 Add this function to manually refresh
    func refreshLocation() {
        print("Refreshing location...")
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Received location update: \(locations)")
        guard let location = locations.last else { return }
        reverseGeocode(location: location)
//        // 👇 Optional: stop updates after getting one result to save battery
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        userLocationDescription = "Unable to get address"
    }
    
    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
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
