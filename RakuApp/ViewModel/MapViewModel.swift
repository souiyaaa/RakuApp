    import Foundation
    import MapKit
    import SwiftUI
    import CoreLocation

    class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        private let locationManager = CLLocationManager()
        @Published var locationString: String = ""
      
        @Published var searchText = ""
        @Published var searchResults: [MapModel] = []
        @Published var selectedLocation: MapModel?
        @Published var showingSearchResults = false
        @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -7.29025, longitude: 112.63048),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        @Published var userLocation: CLLocationCoordinate2D? {
            didSet {
                if let location = userLocation {
                    region = MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
            }
        }

        func selectLocation(_ item: MapModel) {
             selectedLocation = item
             searchText = item.name
             showingSearchResults = false

             region = MKCoordinateRegion(
                 center: item.coordinate,
                 span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
             )
            
            locationString = "\(item.name), \(item.address)"
               print("Selected location string: \(locationString)")
            
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
         }
        
        func searchForLocation() {
                let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    searchResults = []
                    showingSearchResults = false
                    return
                }

                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = trimmed
                request.region = region

                let search = MKLocalSearch(request: request)
                search.start { response, error in
                    DispatchQueue.main.async {
                        if let response = response {
                            self.searchResults = response.mapItems.map { MapModel(mapItem: $0) }
                            self.showingSearchResults = !self.searchResults.isEmpty
                        } else {
                            print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                            self.searchResults = []
                            self.showingSearchResults = false
                        }
                    }
                }
            }


        func hideSearchResults() {
            showingSearchResults = false
        }
        override init() {
               super.init()
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestWhenInUseAuthorization()
               locationManager.startUpdatingLocation()
           }

           func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
               if let location = locations.last {
                   DispatchQueue.main.async {
                       self.userLocation = location.coordinate
                   }
               }
           }

           func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
               print("Location error: \(error.localizedDescription)")
           }
    }
