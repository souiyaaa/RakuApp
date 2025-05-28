//
//  RegisterView.swift
//  RakuApp
//
//  Created by Surya on 22/05/25.
//

import SwiftUI

struct RegisterView: View {
    @Binding var registerClicked: Bool
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var userVM: UserViewModel
    


    var body: some View {
        ZStack {

            //top area decor
            GeometryReader { geometry in
                Circle()
                    .stroke(Color(hex: "E1E7FF"), lineWidth: 1)
                    .frame(width: 306, height: 306)
                    .position(
                        x: geometry.size.width - 100,
                        y: 57
                    )
            }
            .ignoresSafeArea()

            GeometryReader { geometry in
                Circle()
                    .fill(Color(hex: "CCD6FF"))
                    .frame(width: 140, height: 140)
                    .position(x: geometry.size.width - 30, y: 40)
                    .blur(radius: 40)
            }
            .ignoresSafeArea()

            //bottom area decor
            GeometryReader { geometry in
                Circle()
                    .stroke(Color(hex: "E1E7FF"), lineWidth: 1)
                    .frame(width: 306, height: 306)
                    .position(
                        x: 75,
                        y: 800
                    )
            }
            .ignoresSafeArea()

            GeometryReader { geometry in
                Circle()
                    .fill(Color(hex: "CCD6FF"))
                    .frame(width: 250, height: 250)
                    .position(x: 30, y: 800)
                    .blur(radius: 60)
            }
            .ignoresSafeArea()

            GeometryReader { geometry in
                Image("Full Deco")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 475, height: 475)
                    .position(x: 300, y: 775)
            }

            VStack {
                VStack {
                    Text("Register Here")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 12)

                    Text("Welcome back you've \nbeen missed")
                        .multilineTextAlignment(.center)
                        .font(.body)
                }
                .padding(.bottom, 40)

                VStack {
                    TextField("Name", text: $userVM.myUserData.name)
                        .padding(.horizontal, 16)
                        .frame(width: 361, height: 50)
                        .background(Color(hex: "F1F4FF"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "1F41BA"), lineWidth: 1)
                        )
                        .cornerRadius(8)
                        .padding(.bottom, 12)

                    TextField("Email", text: $userVM.myUserData.email)
                        .padding(.horizontal, 16)
                        .frame(width: 361, height: 50)
                        .background(Color(hex: "F1F4FF"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "1F41BA"), lineWidth: 1)
                        )
                        .cornerRadius(8)
                        .padding(.bottom, 12)

                    SecureField("Password", text: $userVM.myUserData.password)
                        .padding(.horizontal, 16)
                        .frame(width: 361, height: 50)
                        .background(Color(hex: "F1F4FF"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "1F41BA"), lineWidth: 1)
                        )
                        .cornerRadius(8)
                }

                Button(
                    action: {
                        Task {
                            await authVM.signUp(
                                email: userVM.myUserData.email,
                                password: userVM.myUserData.password,
                                name: userVM.myUserData.name)
                            if !authVM.falseCredential {
                                authVM.checkUserSession()
                                // Clear user data after signup
                                userVM.myUserData = MyUser()
                                authVM.isSignedIn = true
                            }
                        }
                    }
                ) {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(hex: "1F41BA"))
                        .cornerRadius(10)
                        .font(.headline)
                }
                .frame(width: 361, height: 50)
                .padding(.top, 80)

                Button(
                    action: {
                        registerClicked = false
                    }
                ) {
                    Text("Already have an account")
                        .foregroundColor(Color(hex: "1F41BA"))
                        .fontWeight(.medium)
                }
                .padding(.top, 8)

                Spacer()

            }
            .padding(.top, 42)

        }
    }
}

#Preview {
    let userVM = UserViewModel()
    let authVM = AuthViewModel(userViewModel: userVM)

    return RegisterView(registerClicked: .constant(true))
        .environmentObject(authVM)
        .environmentObject(userVM)
}
