import SwiftUI

struct SplashView: View {
    @State var isStarted: Bool = false

    var body: some View {
        ZStack {
            // Background decorative circles
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color(hex: "CCD6FF"))
                        .frame(width: 140, height: 140)
                        .blur(radius: 40)
                        .offset(x: 30, y: -20)
                }
                Spacer()
            }

            VStack {
                Circle()
                    .stroke(Color(hex: "E1E7FF"), lineWidth: 1)
                    .frame(width: 306, height: 306)
                    .offset(y: -320)
                Spacer()
            }

            // Content
            VStack {
                Text("Raku")
                    .fontWeight(.bold)
                    .font(.title)

                Image("SplashAsset")
                    .resizable()
                    .scaledToFit()
                    .padding(.leading, 80)
                    .offset(y: 40)

                Text("Find Your Badminton \nbuddy")
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("You can find your buddy to be here. \nIm thrilled to see you on board!")
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .font(.body)

                Button(action: {
                    isStarted = true
                }) {
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
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isStarted) {
            LoginView(showAuthPage: $isStarted)
        }
    }
}

#Preview {
    SplashView()
}
