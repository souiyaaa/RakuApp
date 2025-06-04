//
//  MatchDetailView.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import SwiftUI

struct MatchDetailView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 4) {
                        Text("YOU ARE")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.5))
                        Text("INVITED")
                            .font(.title2)
                            .italic()
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .red.opacity(0.2),
                                .orange.opacity(0.2),
                                .yellow.opacity(0.2),
                                .green.opacity(0.2),
                                .blue.opacity(0.2),
                                .purple.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .ignoresSafeArea(edges: .horizontal)

                    // Match Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Saturday Morning Match")
                            .font(.title2).bold()
                        Text("Central Park Court 3")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(spacing: -10) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 30, height: 30)
                                    .overlay(Text("P\(index + 1)").foregroundColor(.white))
                            }
                            Text("+2")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Text("5 Participants")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Actions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What do you want to do?")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 16) {
                            ActionButtonView(color: .green, icon: "sportscourt", label: "Be Referee")

                            NavigationLink(destination: SinglesView()) {
                                ActionButtonView(color: .blue, icon: "person", label: "Singles")
                            }

                            NavigationLink(destination: DoublesView()) {
                                ActionButtonView(color: .orange, icon: "person.2", label: "Doubles")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Current Match
                    VStack(spacing: 8) {
                        Text("Current Match")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Alice")
                                Text("Bob")
                            }
                            .font(.caption)
                            .foregroundColor(.white)

                            Spacer()

                            Text("15")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)

                            Spacer()

                            VStack {
                                Text("12:10")
                                Text("Weston")
                            }
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)

                            Spacer()

                            Text("13")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("Charlie")
                                Text("Diana")
                            }
                            .font(.caption)
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 0.0, green: 0.2, blue: 0.5))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // History
                    VStack(alignment: .leading, spacing: 8) {
                        Text("History")
                            .font(.headline)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Saturday Morning Match")
                                    .font(.subheadline).bold()
                                Text("Double - 3 Set")
                                    .font(.caption)
                            }
                            Spacer()
                            Text("5 Participants")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Current Match")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ActionButtonView: View {
    var color: Color
    var icon: String
    var label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(color.opacity(0.2))
                .clipShape(Circle())

            Text(label)
                .font(.footnote)
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(color.opacity(1))
        .cornerRadius(20)
    }
}

#Preview {
    MatchDetailView()
}
