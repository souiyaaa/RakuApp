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
