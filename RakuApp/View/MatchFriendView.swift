//
//  MatchFriendView.swift
//  RakuApp
//
//  Created by student on 09/06/25.
//

import SwiftUI

struct MatchFriendView: View {
    @ObservedObject var userVM: UserViewModel
    @Binding var selectedUsers: [MyUser]
    @State private var showLimitAlert = false
    @State private var searchText = ""
    let maxSelection: Int

    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            List {
                ForEach(userVM.myUserDatas.filter {
                    searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased())
                }, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if selectedUsers.contains(where: { $0.id == user.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(of: user)
                    }
                }
            }
        }
        .navigationTitle("Choose Players")
        .alert("You can only select up to \(maxSelection) players.", isPresented: $showLimitAlert) {
            Button("OK", role: .cancel) { }
        }
    }


    private func toggleSelection(of user: MyUser) {
        if let index = selectedUsers.firstIndex(where: { $0.id == user.id }) {
            selectedUsers.remove(at: index)
        } else {
            if selectedUsers.count < maxSelection {
                selectedUsers.append(user)
            } else {
                showLimitAlert = true
            }
        }
    }
}

