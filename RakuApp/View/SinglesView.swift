//
//  SinglesView.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import SwiftUI

struct SinglesView: View {
    @State private var bestOf = 3
    @State private var gameUpTo = 21
    @State private var maxScore = 30

    var body: some View {
        VStack(spacing: 20) {
            // 🏸 코트: 2개는 빈 박스, 2개는 선수
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    EmptyCourtBox()
                    SinglePlayerView(name: "Player 1")
                }
                HStack(spacing: 20) {
                    SinglePlayerView(name: "Player 2")
                    EmptyCourtBox()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)

            // 참가자 명단 (1:1 싱글용)
            VStack(alignment: .leading, spacing: 10) {
                Text("Participants")
                    .font(.headline)
                HStack(spacing: 20) {
                    SingleTeamBox(title: "Team 1", color: Color.blue.opacity(0.1))
                    SingleTeamBox(title: "Team 2", color: Color.red.opacity(0.1))
                }
            }
            .padding(.horizontal)

            // 설정
            VStack(spacing: 10) {
                SingleSettingRow(title: "Best of", value: $bestOf)
                SingleSettingRow(title: "Game up to", value: $gameUpTo, highlighted: true)
                SingleSettingRow(title: "Max Score", value: $maxScore)
            }
            .padding(.horizontal)

            // 버튼
            Button("Random Match Detail") {}
                .foregroundColor(.blue)

            Button(action: {}) {
                Text("Start Match")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct SinglePlayerView: View {
    var name: String

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
            Text(name)
                .font(.body)
        }
        .frame(width: 140, height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct EmptyCourtBox: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.4))
            .frame(width: 140, height: 80)
            .cornerRadius(12)
    }
}

struct SingleTeamBox: View {
    let title: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: "xmark.circle")
        }
        .padding(8)
        .background(color)
        .cornerRadius(8)
        .frame(width: 150)
    }
}

struct SingleSettingRow: View {
    var title: String
    @Binding var value: Int
    var highlighted: Bool = false

    var body: some View {
        HStack {
            Text("\(title): \(value)")
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading)

            Spacer()

            HStack(spacing: 0) {
                Button(action: {
                    if value > 1 { value -= 1 }
                }) {
                    Text("−")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 24, weight: .medium))
                }

                Divider()
                    .frame(height: 24)

                Button(action: {
                    value += 1
                }) {
                    Text("+")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 24, weight: .medium))
                }
            }
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.trailing)
        }
        .frame(height: 60)
        .background(highlighted ? Color(UIColor.systemGray5) : Color.clear)
        .cornerRadius(12)
    }
}

#Preview {
    SinglesView()
}

