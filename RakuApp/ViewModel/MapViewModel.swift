import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.2575, longitude: 112.7521),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @Published var searchText = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var selectedLocation: MKMapItem?
    @Published var showingSearchResults = false

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
                    self.searchResults = response.mapItems
                    self.showingSearchResults = !response.mapItems.isEmpty
                } else {
                    print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                    self.searchResults = []
                    self.showingSearchResults = false
                }
            }
        }
    }

    func selectLocation(_ item: MKMapItem) {
        selectedLocation = item
        searchText = item.name ?? ""
        showingSearchResults = false

        region = MKCoordinateRegion(
            center: item.placemark.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func hideSearchResults() {
        showingSearchResults = false
    }
}
