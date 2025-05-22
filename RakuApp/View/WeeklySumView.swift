//
//  WeeklySumView.swift
//  RakuApp
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct WeeklySumView: View {
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(20)

            ZStack(alignment: .topLeading) {
                Color(
                    red: 237 / 255,
                    green: 237 / 255,
                    blue: 237 / 255
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color(
                                red: 192 / 255,
                                green: 192 / 255,
                                blue: 192 / 255
                            ),
                            lineWidth: 1
                        )
                )
                
                Text("📊 Weekly Summary")
                    .font(.subheadline)
                    .padding(.leading, 16)
                    .padding(.top, 8)

                VStack {
                    Spacer()
                    ZStack {
                        Color.white
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color(
                                            red: 192 / 255,
                                            green: 192 / 255,
                                            blue: 192 / 255
                                        ),
                                        lineWidth: 1
                                    )
                            )

                        HStack(alignment: .top, spacing: 0) {
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
                            .padding(.leading, 20)

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
                            .padding(.leading, 70)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 361, height: 149)
                }
            }
            .frame(width: 361, height: 180)
        }
        .frame(width: 393, height: 212)
    }
}

#Preview {
    WeeklySumView()
}
