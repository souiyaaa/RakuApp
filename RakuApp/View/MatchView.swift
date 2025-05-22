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
                //Row pertama
                HStack {
                    Image("account")
                    VStack{
                        HStack{
                            Text("Kezia Allen you are at"
                            ).font(.body).multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack{
                            Text("Universitas Ciputra"
                            ).font(.headline).multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal,4)
                    Button("Logout") {
                        authVM.signOut()
                        
                    }
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MatchView()
        .environmentObject(AuthViewModel())
}
