import SwiftUI

struct LeaderboardView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: geometry.size.width * 0.05) {
                let podiumWidth = geometry.size.width * 0.28

                PodiumPlaceView(
                    rank: "2",
                    name: "Ardi",
                    points: "80 points",
                    color: Color(white: 0.8)
                )
                .frame(width: podiumWidth, height: geometry.size.height * 0.75)

                PodiumPlaceView(
                    rank: "1",
                    name: "Josua",
                    points: "150 points",
                    color: .yellow
                )
                .frame(width: podiumWidth, height: geometry.size.height * 0.9)

                PodiumPlaceView(
                    rank: "3",
                    name: "Surya",
                    points: "70 points",
                    color: Color(red: 0.8, green: 0.5, blue: 0.2)
                )
                .frame(width: podiumWidth, height: geometry.size.height * 0.65)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct PodiumPlaceView: View {
    let rank: String
    let name: String
    let points: String
    let color: Color

    var body: some View {
        VStack {
            Text(rank)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(color)
            Spacer()
            Text(name)
                .font(.headline)
            Text(points)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 5, y: 5)
    }
}

#Preview {
    LeaderboardView()
        .frame(height: 200)
        .padding()
}
