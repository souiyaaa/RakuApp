//
//  AuthViewModel.swift
//  RakuApp
//
//  Created by Surya on 21/05/25.
//

import FirebaseAuth
import Foundation
import GoogleSignIn
import FirebaseDatabase



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

    
    func fetchUserName() -> String{
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid               // Firebase UID
            let email = user.email           // User's email
            let displayName = user.displayName // User's display name (if set)

            print("UID: \(uid)")
            print("Email: \(email ?? "No email")")
            print("Display Name: \(displayName ?? "No name")")
            
            return displayName ?? "No name"
        } else {
            print("No user is currently signed in.")
            return ""
        }
    }

    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(" No logged in user.")
            return
        }

        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            guard let value = snapshot.value as? [String: Any] else {
                print(" Failed to cast user data")
                return
            }
            
         

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(MyUser.self, from: jsonData)
                DispatchQueue.main.async {
                    self.myUser = user
                    print("User data fetched: \(self.myUser)")
                }
            } catch {
                print(" Decoding error: \(error.localizedDescription)")
            }
        }
    }


    func checkUserSession() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = self.user != nil
        
        print("sign in 3")
        print(isSignedIn)
        if isSignedIn {
            fetchUserData()
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

    func signIn() async {
        print("sign in")
        do {
            _ = try await Auth.auth().signIn(
                withEmail: myUser.email, password: myUser.password)
            DispatchQueue.main.async {
                self.falseCredential = false
                print("sign in 2")
                self.checkUserSession()
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
            self.checkUserSession()
        } catch {
            print("sign up Error: \(error.localizedDescription) ")
        }
    }

    //google signin here

    //google signout here

}
