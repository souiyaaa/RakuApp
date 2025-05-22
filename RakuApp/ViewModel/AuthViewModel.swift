//
//  AuthViewModel.swift
//  RakuApp
//
//  Created by Surya on 21/05/25.
//

import FirebaseAuth
import Foundation
import GoogleSignIn

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool
    @Published var myUser: MyUser

    @Published var falseCredential: Bool

    init() {
        self.user = nil
        self.isSignedIn = false
        self.falseCredential = false
        self.myUser = MyUser()
        self.checkUserSession()
    }

    func checkUserSession() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = self.user != nil
    }

    func signOut() {
        do {
            try Auth.auth().signOut()

        } catch {
            print("Sign out Error: \(error.localizedDescription)")
        }
    }

    func signIn() async {
        do {
            _ = try await Auth.auth().signIn(
                withEmail: myUser.email, password: myUser.password)
            DispatchQueue.main.async {
                self.falseCredential = false
            }
        } catch {
            DispatchQueue.main.async {
                self.falseCredential = true
            }
        }
    }

    func signUp() async {
        do {
            let _ = try await Auth.auth().createUser(
                withEmail: myUser.email, password: myUser.password)
            self.falseCredential = false
        } catch {
            print("sign up Error: \(error.localizedDescription) ")
        }
    }
    
    //google signin here
    
    //google signout here
    
    
    
}
