import SwiftUI
import MapKit

struct MapCard: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                headerView

                // Search Bar
                searchBar

                // Map and Bottom Sheet
                ZStack(alignment: .bottom) {
                    Map(
                        coordinateRegion: $viewModel.region,
                        annotationItems: viewModel.selectedLocation.map { [MapModel(mapItem: $0)] } ?? []
                    ) { annotation in
                        MapMarker(coordinate: annotation.coordinate, tint: .red)
                    }
                    .padding(.top,10)
                    .onTapGesture {
                        viewModel.hideSearchResults()
                    }

                    if let selected = viewModel.selectedLocation {
                        bottomSheet(for: selected)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }

            if viewModel.showingSearchResults && !viewModel.searchResults.isEmpty {
                searchResultsOverlay
            }
        }
    }

    private var headerView: some View {
        HStack {
            Button(action: {}) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            }

            Spacer()

            Text("Add Location")
                .fontWeight(.semibold)

            Spacer()

            Button(action: {}) {
                Image(systemName: "qrcode.viewfinder")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }

    private var searchBar: some View {
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
    }

    private func bottomSheet(for selected: MKMapItem) -> some View {
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
                    Spacer()
                }

                HStack(spacing: 4) {
                    Image(systemName: "location")
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

            Button(action: {}) {
                Text("Choose Location")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
//        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }

    private var searchResultsOverlay: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.searchResults.prefix(5), id: \.self) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name ?? "Unknown")
                        .font(.system(size: 16, weight: .medium))

                    if let address = item.placemark.title {
                        Text(address)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
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
        .padding(.top, 110)
        .zIndex(2)
    }
}

#Preview {
    MapCard()
}
