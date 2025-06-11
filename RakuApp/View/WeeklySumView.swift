import SwiftUI

struct WeeklySumView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Weekly Summary")
                .font(.headline)
                .padding(.horizontal)

            ZStack {
                Color.white
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 5)
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Total energy burned")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("\(activityVM.formattedCalories(activityVM.calories)) kcal")
                            .font(.body)
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Total standing time")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("\(Int(activityVM.standingTime)) minutes")
                            .font(.body)
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Exercise time total")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("\(Int(activityVM.exerciseTime)) minutes")
                            .font(.body)
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Total game")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("5 Games")
                            .font(.body)
                            .bold()
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                await activityVM.fetchData()
            }
        }
    }
}
