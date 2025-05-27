import SwiftUI
import MapKit

struct AddLocationScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.2575, longitude: 112.7521), // Surabaya
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedLocation: MKMapItem?
    @State private var showingSearchResults = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("Add Location")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        // QR code action
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    
                    TextField("Search court, location", text: $searchText)
                        .font(.system(size: 16))
                        .onChange(of: searchText) { newValue in
                            if !newValue.isEmpty {
                                searchForLocation()
                            } else {
                                searchResults = []
                                showingSearchResults = false
                            }
                        }
                        .onSubmit {
                            searchForLocation()
                        }
                    
                    Spacer()
                    
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
                
                // Map + Bottom Card
                ZStack(alignment: .bottom) {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: selectedLocation != nil ? [LocationAnnotation(mapItem: selectedLocation!)] : []
                    ) { annotation in
                        MapMarker(coordinate: annotation.coordinate, tint: .red)
                    }
                    .padding(.top,10)
                    .onTapGesture {
                        hideSearchResults()
                    }
                    
                    if let selected = selectedLocation {
                        VStack(spacing: 0) {
                            HStack {
                                Text("10 Agustus 2025, 09:13 WIB")
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(16)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(selected.name ?? "No destination chosen")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "location")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text(selected.placemark.title ?? "No address available")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            Button(action: {
                                // Choose location action
                            }) {
                                Text("Choose Location")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            if showingSearchResults && !searchResults.isEmpty {
                VStack(spacing: 0) {
                    ForEach(searchResults.prefix(5), id: \.self) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name ?? "Unknown")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            if let address = item.placemark.title {
                                Text(address)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectLocation(item)
                        }
                        
                        if item != searchResults.prefix(5).last {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 110)
                .zIndex(2)
            }
        }
    }
    
    private func searchForLocation() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            showingSearchResults = false
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.searchResults = []
                    self.showingSearchResults = false
                }
                return
            }

            DispatchQueue.main.async {
                self.searchResults = response.mapItems
                self.showingSearchResults = !response.mapItems.isEmpty
            }
        }
    }

    private func selectLocation(_ item: MKMapItem) {
        selectedLocation = item
        withAnimation {
            self.showingSearchResults = false
        }
        searchText = item.name ?? ""

        region = MKCoordinateRegion(
            center: item.placemark.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func hideSearchResults() {
        showingSearchResults = false
    }
}

// MARK: - Location Annotation
struct LocationAnnotation: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem

    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }

    var name: String {
        mapItem.name ?? "Unknown Location"
    }
}

// MARK: - Rounded Corner Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    AddLocationScreen()
}
