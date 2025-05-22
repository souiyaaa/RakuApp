//
//  SplashView.swift
//  RakuApp
//
//  Created by Surya on 22/05/25.
//

import SwiftUI

struct SplashView: View {
    @State var isStarted: Bool = false
    
    var body: some View {
        ZStack {
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

            VStack {
                Text("Raku")
                    .fontWeight(.bold)
                    .font(.title)
              
                Image("SplashAsset")
                    .resizable()
                    .scaledToFit()
                    .padding(.leading, 80)
                    .offset(y: 40) // move image downward slightly

                Text("Find Your Badminton \nbuddy")
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("You can find your buddy to be here. \nIm thrilled to see you on board!")
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .font(.body)
                
                Button(
                    action: {
                        isStarted = true
                        }
                    
                ) {
                    Text("Start now")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(hex: "1F41BA"))
                        .cornerRadius(10)
                        .font(.headline)
                }
                .frame(width: 361, height: 50)
                .padding(.top, 60)
                
                Spacer()
                

            }
            .padding(.top, 12)

        }.fullScreenCover(isPresented: $isStarted) {
            LoginView(showAuthPage: $isStarted)
        }

    }
}

#Preview {
    SplashView()
}
