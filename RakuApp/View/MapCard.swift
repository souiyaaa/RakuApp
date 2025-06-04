import SwiftUI
import MapKit

struct MapCard: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            // Map background
            Map(
                coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.selectedLocation.map { [$0] } ?? []
            ) { annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)

            // Foreground overlay: Search bar + ProgressView
            VStack(spacing: 8) {
                // Search bar at top
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search court, location", text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.searchForLocation()
                        }
                        .onSubmit {
                            viewModel.searchForLocation()
                        }

                    Spacer()

                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 16) // space from top safe area

                // Progress bar
                HStack {
                    ProgressView(value: 1)
                        .tint(Color(hex: "1F41BA"))
                }
                .padding(.horizontal, 16)
                .background(Color.clear)

                Spacer() // push everything up
            }

            // Search Results Overlay
            if viewModel.showingSearchResults && !viewModel.searchResults.isEmpty {
                VStack(spacing: 0) {
                    ForEach(viewModel.searchResults.prefix(5)) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.system(size: 16, weight: .medium))

                            Text(item.address)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemBackground))
                        .onTapGesture {
                            viewModel.selectLocation(item)
                        }

                        if item != viewModel.searchResults.prefix(5).last {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding(.horizontal, 16)
                .padding(.top, 120)
                .zIndex(2)
            }
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MapCard()
}
