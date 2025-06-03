import SwiftUI

struct WeeklySumView: View {
    @StateObject var viewModel: ActivityViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📊 Weekly Summary")
                .font(.subheadline)
                .padding(.top, 14)
                .padding(.leading, 16)

            VStack(alignment: .leading) {
                Text("Total energy burned")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text(String(format: "%.1f kcal", viewModel.calories))
                    .font(.body)
                    .bold()

                Button(action: {
                    Task {
                        await viewModel.fetchData()
                    }
                }) {
                    Text("Refresh Data")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}
