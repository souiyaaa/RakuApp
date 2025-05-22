import SwiftUI

struct LearnCard: View {
    var title: String
    var videoID: String
    var publisher: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ZStack(alignment: .topTrailing) {
                Button(action: {
                    if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 154, height: 87)
                    .clipped()
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle()) // hilangkan animasi klik default dari button

                Image(systemName: "play.rectangle.fill")
                    .resizable()
                    .frame(width: 22, height: 15)
                    .foregroundColor(.red)
                    .padding(6)
            }

            Text(title.count > 30 ? String(title.prefix(30)) + "..." : title)
                .font(.subheadline)
                .lineLimit(1)

            Text(publisher)
                .font(.caption)
                .foregroundColor(Color(red: 140/255, green: 133/255, blue: 133/255))
        }
        .padding()
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .frame(width: 154)
    }
}
