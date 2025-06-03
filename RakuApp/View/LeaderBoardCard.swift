//
//  LeaderboardCard.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//


import SwiftUI

struct LeaderboardCard: View {
    @StateObject private var viewModel = LeaderboardViewModel()

    var body: some View {
        LazyVStack(spacing: 4) {
            ForEach(viewModel.leaderboardM.filter { $0.rank >= 4 }) { leaderboardItem in
                HStack(spacing: 12) {
                    Text("\(leaderboardItem.rank)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                    Text(leaderboardItem.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Spacer()
                    Text("\(leaderboardItem.points) pts")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(leaderboardItem.points > 0 ? .secondary : Color.gray.opacity(0.7))
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
            }
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.fetchAndProcessUsers()
        }
    }
}

#Preview {
    LeaderboardCard()
}
