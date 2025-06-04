//
//  MatchView.swift
//  RakuApp
//
//  Created by Surya on 22/05/25.
//

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("account")
                    VStack {
                        HStack {
                            Text(
                                "Kezia Allen you are at"
                            ).font(.body).multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            Text(
                                "Universitas Ciputra"
                            ).font(.headline).multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 4)
                    Button("Logout") {
                        authVM.signOut()

                    }
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                }
                .padding()
                Spacer()
                ScoreCard()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Events")
                            .font(.headline)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    CalendarView()
                
                    HStack {
                        Spacer()
                        NavigationLink(destination: MatchDetailView()) {
                            VStack(spacing: 4) {
                                Text("YOU ARE")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.5))
                                Text("INVITED")
                                    .font(.title2)
                                    .italic()
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 32)
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
                            .cornerRadius(24)
                            .shadow(radius: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    .padding(.top, 0) // ⬅️ 위로 올림 (기존 4 → 0)



                    .ignoresSafeArea(edges: .horizontal)

                }
                
            }
            .navigationTitle("Matches")
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        }
    }
}

#Preview {
    MatchView()
        .environmentObject(AuthViewModel())
        .environmentObject(CalendarViewModel())
}
