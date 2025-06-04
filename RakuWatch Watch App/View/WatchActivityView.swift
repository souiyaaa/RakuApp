//
//  WatchActivityView.swift
//  RakuWatch Watch App
//
//  Created by Surya on 04/06/25.
//

import SwiftUI


struct WatchActivityView: View {
    @StateObject var viewModel = WatchActivityViewModel()

    var body: some View {
        VStack(spacing: 10) {
            Text("Today's Activity")
                .font(.headline)

            HStack {
                VStack {
                    Text("Calories")
                    Text("\(Int(viewModel.calories)) kcal")
                        .bold()
                }
                VStack {
                    Text("Exercise")
                    Text("\(Int(viewModel.exerciseTime)) min")
                        .bold()
                }
                VStack {
                    Text("Standing")
                    Text("\(Int(viewModel.standingTime)) min")
                        .bold()
                }
            }
            .font(.caption)

            Button("Refresh") {
                Task {
                    await viewModel.fetchActivityData()
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.requestHealthAuthorization()
            }
        }
    }
}


#Preview {
    WatchActivityView()
}
