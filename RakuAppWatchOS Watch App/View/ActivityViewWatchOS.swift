//
//  ActivityView.swift
//  RakuAppWatchOS Watch App
//
//  Created by student on 30/05/25.
//

import SwiftUI

struct WeeklySumViewWatch: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    let cardPadding: CGFloat = 8
    let itemSpacing: CGFloat = 6

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("📊 Weekly Summary")
                    .font(.headline)
                    .padding([.top, .leading], cardPadding)
                    .padding(.bottom, 4)

                VStack(alignment: .leading, spacing: itemSpacing) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "flame.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total energy burned")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.activity.TotalEnergyBurned) Kcal")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Exercise time total")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.activity.ExerciseTime) minutes")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "figure.stand")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total standing time")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.activity.TotalStandingTime) minutes")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total games")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.activity.TotalGame) Games")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding([.horizontal, .bottom], cardPadding)
            }
        }
    }
}
#Preview {
    NavigationView {
        WeeklySumViewWatch(viewModel: ActivityViewModel())
            .navigationTitle("Summary")
            .padding(.horizontal, 4)
    }
    .environment(\.colorScheme, .dark)
}
