//
//  ScoreCard.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import SwiftUI

struct ScoreCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                HStack(spacing: 32) {
                    VStack(alignment: .trailing) {
                        Text("Ver")
                            .font(.caption2)
                        Text("Del")
                            .font(.caption2)
                    }
                    .foregroundColor(.white)

                    Text("12")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    VStack(spacing: 2) {
                        Text("12:10")
                            .font(.caption2)
                            .foregroundColor(.white)

                        Text("Weston")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }

                    Text("12")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    VStack(alignment: .leading) {
                        Text("Pat")
                            .font(.caption2)
                        Text("Cio")
                            .font(.caption2)
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
            .background(Color(red: 37 / 255, green: 51 / 255, blue: 102 / 255))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ScoreCard()
}
