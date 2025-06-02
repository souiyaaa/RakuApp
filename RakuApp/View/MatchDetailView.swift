//
//  MatchDetailView.swift
//  RakuApp
//
//  Created by Student on 02/06/25.
//

import SwiftUI

struct MatchDetailView: View {
    @ObservedObject var viewModel: MatchViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                Text("YOU ARE")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.black)
                Text("INVITED")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                // Match Info Card
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.match.name)
                        .font(.title2).bold()
                    Text(viewModel.match.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: -10) {
                        ForEach(viewModel.match.players.prefix(3)) { user in
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 30, height: 30)
                                .overlay(Text(user.name.prefix(1)).foregroundColor(.white))
                        }
                        if viewModel.participantCount > 3 {
                            Text("+\(viewModel.participantCount - 3)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Text("\(viewModel.participantCount) Participants")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                
                // Actions
                HStack(spacing: 16) {
                    ActionButtonView(color: .green, icon: "whistle", label: "Be Referee")
                    ActionButtonView(color: .blue, icon: "person", label: "Singles")
                    ActionButtonView(color: .orange, icon: "person.2", label: "Doubles")
                }
                
                // Current Match
                if let game = viewModel.currentGame {
                    VStack(spacing: 8) {
                        Text("Current Match")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            VStack {
                                Text(game.leftPlayers.map { $0.name }.joined(separator: "\n"))
                                    .font(.caption)
                                Text("\(game.leftScore)")
                                    .font(.largeTitle)
                                    .bold()
                            }
                            Spacer()
                            Text("12:10\nWeston")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                            Spacer()
                            VStack {
                                Text(game.rightPlayers.map { $0.name }.joined(separator: "\n"))
                                    .font(.caption)
                                Text("\(game.rightScore)")
                                    .font(.largeTitle)
                                    .bold()
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                
                // History Placeholder
                VStack(alignment: .leading) {
                    Text("History")
                        .font(.headline)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.match.name)
                                .font(.subheadline).bold()
                            Text("Double - 3 Set")
                                .font(.caption)
                        }
                        Spacer()
                        Text("\(viewModel.participantCount) Participants")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Current Match")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActionButtonView: View {
    var color: Color
    var icon: String
    var label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .padding()
                .background(color.opacity(0.2))
                .clipShape(Circle())
            Text(label)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MatchDetailView(viewModel: MatchViewModel)
}
