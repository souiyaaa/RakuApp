import SwiftUI

struct LeaderboardView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {

            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 111, height: 100)
                    .padding(.top,5)

                Text("2")
                    .font(.system(size: 100, weight: .bold))
                    .italic()
                    .offset(x: 8, y: -15)
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 0.867,
                                    green: 0.882,
                                    blue: 0.898,
                                    opacity: 0.9
                                ),
                                Color.white,
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Text("2")
                                .font(.system(size: 100, weight: .bold))
                                .italic()
                                .offset(x: 8, y: -15)
                        )
                    )

                VStack(spacing: 4) {
                    Text("Ardi")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.black)

                    Text("80 points")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(width: 111)
                .multilineTextAlignment(.center)
                .position(x: 112 / 2, y: 102 - 25)
            }
            .frame(width: 111, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color(red: 0.392, green: 0.392, blue: 0.435, opacity: 0.2), radius: 4, x: 0, y: 0)


            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 112, height: 112)

                Text("1")
                    .font(.system(size: 100, weight: .bold))
                    .italic()
                    .offset(x: 6, y: -22)
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 0.996,
                                    green: 0.792,
                                    blue: 0.565,
                                    opacity: 0.9
                                ),
                                Color.white,
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Text("1")
                                .font(.system(size: 100, weight: .bold))
                                .italic()
                                .offset(x: 6, y: -22)
                        )
                    )

                VStack(spacing: 4) {
                    Text("Josua")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.black)

                    Text("150 points")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(width: 112)
                .multilineTextAlignment(.center)
                .position(x: 112 / 2, y: 102 - 25)
            }
            .frame(width: 112, height: 112)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color(red: 0.392, green: 0.392, blue: 0.435, opacity: 0.2), radius: 4, x: 0, y: 0)


            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 111, height: 90)
                    .padding(.top,12)

                Text("3")
                    .font(.system(size: 100, weight: .bold))
                    .italic()
                    .offset(x: 8, y: -10)
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 214 / 255,
                                    green: 189 / 255,
                                    blue: 185 / 255,
                                    opacity: 0.9
                                
                                ),
                                Color.white,
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Text("3")
                                .font(.system(size: 100, weight: .bold))
                                .italic()
                                .offset(x: 8, y: -10)
                        )
                    )

                VStack(spacing: 4) {
                    Text("Ardi")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.black)

                    Text("80 points")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(width: 111)
                .multilineTextAlignment(.center)
                .position(x: 112 / 2, y: 102 - 25)
            }
            .frame(width: 111, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color(red: 0.392, green: 0.392, blue: 0.435, opacity: 0.2), radius: 4, x: 0, y: 0)


        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    LeaderboardView()
}
