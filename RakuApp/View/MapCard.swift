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
            .onTapGesture {
                viewModel.hideSearchResults()
            }

            // Foreground overlay: Search bar + ProgressView + Results
            VStack(spacing: 8) {
                // Search bar
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
                .padding(.top, 16)

                // Progress bar
                HStack {
                    ProgressView(value: 1)
                        .tint(Color(hex: "1F41BA"))
                }
                .padding(.horizontal, 16)

                // Search Results
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
                }

                Spacer()
            }

            // Bottom Sheet for Selected Location
            if let selected = viewModel.selectedLocation {
                VStack(spacing: 0) {
                    Spacer()

                    VStack(alignment: .leading, spacing: 12) {
                        Text(selected.name)
                            .font(.headline)

                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.gray)
                            Text(selected.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Button(action: {
                            // Action when user confirms location
                        }) {
                            Text("Choose Location")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom))
                }
                .zIndex(3)
            }
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: viewModel.selectedLocation)
    }
}

#Preview {
    MapCard()
}
