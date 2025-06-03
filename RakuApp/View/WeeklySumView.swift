import SwiftUI

struct WeeklySumView: View {
    @EnvironmentObject  var activityVM: ActivityViewModel

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(20)

            VStack(alignment: .leading, spacing: 8) {
                Text("📊 Weekly Summary")
                    .font(.subheadline)
                    .padding(.top, 14)
                    .padding(.leading, 16)

                ZStack {
                    Color.white
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    HStack(alignment: .top, spacing: 110) {
                        VStack(alignment: .leading, spacing: 28) {
                            VStack(alignment: .leading) {
                                Text("Total energy burned")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("\(activityVM.formattedCalories(activityVM.calories)) kcal")
                                .font(.body)
                                .bold()
                            }
                            VStack(alignment: .leading) {
                                Text("Exercise time total")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("\(Int(activityVM.exerciseTime * 60)) minutes")
                                .font(.body)
                                .bold()
                            }
                        }
                        VStack(alignment: .leading, spacing: 28) {
                            VStack(alignment: .leading) {
                                Text("Total standing time")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("\(Int(activityVM.standingTime * 60)) minutes")

                                .font(.body)
                                .bold()
                            }
                            VStack(alignment: .leading) {
                                Text("Total game")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("9 Games")
                                    .font(.body)
                                    .bold()
                            }
                        }
                        .offset(x: -60)
                    }
                    .padding()
                    .onAppear {
                        Task {
                            await activityVM.fetchData()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color(red: 237 / 255, green: 237 / 255, blue: 237 / 255)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                )
                .padding()
            }
            .aspectRatio(393 / 212, contentMode: .fit)

        }
    }

}
