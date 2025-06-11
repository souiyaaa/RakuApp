//
//  AuthViewModel.swift
//  RakuApp
//
//  Created by Surya on 21/05/25.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation
import GoogleSignIn

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool
    @Published var falseCredential: Bool

   public let userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        self.user = nil
        self.isSignedIn = false
        self.falseCredential = false
        self.checkUserSession()
        self.userViewModel.checkUserPhoto() 
    }

    func checkUserSession() {
        self.user = Auth.auth().currentUser
        DispatchQueue.main.async {
            self.isSignedIn = self.user != nil
            if self.isSignedIn {
                print("sign in berhasil")
                self.userViewModel.fetchUserData()
            }
        }
    }
    
  

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch {
            print("Sign out Error: \(error.localizedDescription)")
        }
    }

    func signIn(email: String, password: String) async {
        do {
            _ = try await Auth.auth().signIn(
                withEmail: email, password: password)
            DispatchQueue.main.async {
                self.falseCredential = false
                self.checkUserSession()
            }
        } catch {
            DispatchQueue.main.async {
                self.falseCredential = true
            }
        }
    }

    func signUp(email: String, password: String, name: String, experience: String) async {
        do {
            let authResult = try await Auth.auth().createUser(
                withEmail: email, password: password)
            let uid = authResult.user.uid

            // Prepare user data in UserViewModel
            var newUser = userViewModel.myUserData
            newUser.id = uid
            newUser.email = email
            newUser.name = name
            newUser.experience = experience

            // Save user data via UserViewModel
            userViewModel.saveUserData(
                user: MyUser(name: name, experience: experience))

            self.falseCredential = false
            self.checkUserSession()
        } catch {
            print("Sign up Error: \(error.localizedDescription)")
        }
    }

    //google signin disini
    //google
}
