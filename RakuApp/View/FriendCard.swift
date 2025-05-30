//
//  FriendCard.swift
//  RakuApp
//
//  Created by Surya on 29/05/25.
//

import SwiftUI

struct FriendCard: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isSelected = false
    var myUser: MyUser

    // Computed property to get the correct image
    var profileImage: UIImage? {
        if myUser.experience == "Beginner" {
            return UIImage(named: "Beginner")
        } else if myUser.experience == "Advance" {
            return UIImage(named: "Advance")
        } else {
            return UIImage(named: "Pro")
        }
    }

    var body: some View {
        ZStack {
            HStack {
                if let uiImage = profileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill") // fallback system image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading){
                    Text(myUser.name)
                        .foregroundColor(.white)

                    Text(myUser.experience + " Player")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                   

                }
                Spacer()
                Button(action: {
                    isSelected.toggle()
                }) {
                    Text(isSelected ? "Selected" : "Select")
                        .foregroundColor(.white)
                        .padding()
                        .background(isSelected ? Color.green : Color.blue)
                        .cornerRadius(8)
                }
                .padding(12)

            }
            .padding(.leading,12)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color.gray)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    let userVM = UserViewModel()
    let authVM = AuthViewModel(userViewModel: userVM)

    return FriendCard(
        myUser: MyUser(id: "" ,email: "surya@gmail.com", name: "Surya", experience: "Pro")
    )
    .environmentObject(authVM)
}
