// souiyaaa/rakuapp/RakuApp-b4efc2de3e01e479eee184089dffb9fa47c7af7d/RakuApp/View/MapCard.swift

import SwiftUI
import MapKit

struct MapCard: View {
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @Binding var isAddEvent: Bool
    @Binding var isChooseFriend: Bool
    @Binding var name: String
    @Binding var description: String
    @Binding var date: Date
    @Binding var courtCost: Double
    @Binding var arrayUser: [MyUser]

    var body: some View {
        ZStack(alignment: .top) {
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


            VStack(spacing: 8) {
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

                HStack {
                    ProgressView(value: 1)
                        .tint(Color(hex: "1F41BA"))
                }
                .padding(.horizontal, 16)

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
                        
                        // FIX: The action for this button is updated
                        Button(action: {
                            // 1. Save the match to Firebase
                            gameViewModel.addMatch(name: name, description: description, date: date, courtCost: courtCost, players: arrayUser, location: viewModel.locationString)
                            
                            // 2. Dismiss all parent sheets to return to MatchView
                            self.isChooseFriend = false
                            self.isAddEvent = false
                            
                        }) {
                            Text("Choose Location & Create Event") // Updated text
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
        .onAppear {
            print(name, description, date, courtCost)
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: viewModel.selectedLocation)
    }
}
