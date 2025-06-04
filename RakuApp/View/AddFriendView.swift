//
//  AddFriendView.swift
//  RakuApp
//
//  Created by Surya on 29/05/25.
//

import SwiftUI
struct AddFriendView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var gameViewModel: GameViewModel

    @State var searchUser = ""
    @State var submitUser : Bool = false
    @State var arrayUser: [MyUser] = []
    
    @Binding var isAddEvent: Bool
    @Binding var isChooseFriend: Bool
    @Binding var name: String
    @Binding var description: String
    @Binding var date: Date
    @Binding var courtCost: Double

    var body: some View {
        VStack {
            ProgressView(value: 0.66)
                .tint(Color(hex: "1F41BA"))
            
            HStack {
                Text("Previous Friend ")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 12)
            
            HStack {
                Text("Add Friend")
                    .font(.headline)
                Spacer()
            }
            
            ScrollView {
                ForEach(gameViewModel.userViewModel.filterUserByName(byName: searchUser)) { user in
                    FriendCard(myUser: user)
                        .onTapGesture {
                            arrayUser.append(user)
                            print(arrayUser)
                        }
                }
            }.searchable(
                text: $searchUser,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            Button(
                action: {
                    gameViewModel.addMatch(name: name, description: description, date: date, courtCost: courtCost, players: arrayUser)
                    arrayUser.removeAll()
                    submitUser = true
                    }
            ) {
                Text("Save Detail")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(hex: "1F41BA"))
                    .cornerRadius(10)
                    .font(.headline)
            }
            .frame(width: 361, height: 50)
            .padding(.top, 12)
            Spacer()
        }
        .padding(.horizontal, 12)
        .background(Color(hex: "F7F7F7"))
        .navigationTitle("Add Friend")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $submitUser) {
            NavigationStack {
                MapCard()
            }
        }
    }
}
#Preview {
    let userVM = UserViewModel()
    let authVM = AuthViewModel(userViewModel: userVM)
    let gameVM = GameViewModel(userViewModel: userVM)
    
    return AddFriendView(
        isAddEvent: .constant(true),
        isChooseFriend: .constant(false),
        name: .constant("Sample Event"),
        description: .constant("This is a description"),
        date: .constant(Date()),
        courtCost: .constant(43000)
    )
    .environmentObject(authVM)
    .environmentObject(gameVM)
}

