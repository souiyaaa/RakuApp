//
//  UserViewModel.swift
//  RakuApp
//
//  Created by Surya on 27/05/25.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class UserViewModel: ObservableObject {
    @Published var myUserData: MyUser
    private var ref: DatabaseReference
    
    init(){
        self.myUserData = MyUser()
        self.ref = Database.database().reference().child("UserData")
    }
    
    //add UserData V1
    func saveUserData(user: MyUser) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No authenticated user to save data for")
            return
        }
        
        guard let email = Auth.auth().currentUser?.email else {
            print("No authenticated user to save data for")
            return
        }

        var userToSave = myUserData
        userToSave.id = uid  // Ensure the id is the current UID
        userToSave.email = email
        userToSave.name = user.name
//        userToSave.password = user.password
        userToSave.experience = user.experience
        
        
        do {
            let jsonData = try JSONEncoder().encode(userToSave)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            guard let userDict = jsonObject as? [String: Any] else {
                print("Failed to convert encoded user to dictionary")
                return
            }
            
            ref.child(uid).setValue(userDict) { error, _ in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User data saved successfully for uid: \(uid)")
                }
            }
        } catch {
            print("JSON encode error: \(error.localizedDescription)")
        }
    }
    

    
    //fetching datas
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(" No authenticated user to fetch data for")
            return
        }

        ref.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print(" Failed to cast snapshot to dictionary")
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(MyUser.self, from: jsonData)
                DispatchQueue.main.async {
                    self.myUserData = user
                    print(" Loaded user data: \(self.myUserData)")
                }
            } catch {
                print(" JSON decode error: \(error.localizedDescription)")
            }
        }
    }
    
    

    
    
}
