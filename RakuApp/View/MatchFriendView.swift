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

    var body: some View {
        List {
            ForEach(userVM.myUserDatas, id: \.id) { user in
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
                    if let index = selectedUsers.firstIndex(where: { $0.id == user.id }) {
                        selectedUsers.remove(at: index)
                    } else {
                        selectedUsers.append(user)
                    }
                }
            }
        }
        .navigationTitle("Choose Players")
    }
}
