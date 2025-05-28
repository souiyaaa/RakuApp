import SwiftUI

struct WeeklySumView: View {
    var body: some View {
        GeometryReader { geo in
            let outerPadding: CGFloat = 16
            let summaryBoxHeight = geo.size.height * 0.85
            let innerBoxHeight = summaryBoxHeight * 0.8
            
            ZStack {
                Color.white
                    .cornerRadius(20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("📊 Weekly Summary")
                        .font(.subheadline)
                        .padding(.top, 8)
                        .padding(.leading, 16)

                    Spacer(minLength: 0)

                    ZStack {
                        Color.white
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color(red: 192/255, green: 192/255, blue: 192/255),
                                        lineWidth: 1
                                    )
                            )

                        HStack(alignment: .top, spacing: geo.size.width * 0.15) {
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading) {
                                    Text("Total energy burned")
                                        .font(.caption)
                                    Text("124 Kcal")
                                        .font(.body)
                                        .bold()
                                }
                                VStack(alignment: .leading) {
                                    Text("Exercise time total")
                                        .font(.caption)
                                    Text("50 minutes")
                                        .font(.body)
                                        .bold()
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading) {
                                    Text("Total standing line")
                                        .font(.caption)
                                    Text("80 minutes")
                                        .font(.body)
                                        .bold()
                                }
                                VStack(alignment: .leading) {
                                    Text("Total game")
                                        .font(.caption)
                                    Text("8 Games")
                                        .font(.body)
                                        .bold()
                                }
                            }
                        }
                        .padding(.horizontal, outerPadding)
                        .padding(.vertical, 16)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 192/255, green: 192/255, blue: 192/255), lineWidth: 1)
                    )
                }
                .padding(outerPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color(red: 237/255, green: 237/255, blue: 237/255)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 192/255, green: 192/255, blue: 192/255), lineWidth: 1)
                        )
                )
                .padding()
            }
        }
        .aspectRatio(393 / 212, contentMode: .fit)
    }
}

#Preview {
    WeeklySumView()
        .padding()
}
