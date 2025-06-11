
import SwiftUI

struct SplitPayment: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            // Check if there is a current match selected
            if let currentMatch = gameViewModel.currentMatch {
                VStack(alignment: .leading) {
                    // Display Total Cost
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Cost")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Rp \(Int(currentMatch.courtCost))")
                            .font(.system(size: 40, weight: .bold))
                    }
                    .padding()

                    Divider()

                    // Header for the list
                    Text("Participants")
                        .font(.headline)
                        .padding(.horizontal)

                    // List of participants in the event
                    List(currentMatch.players) { participant in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                            
                            Text(participant.name)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            // Display checkmark if the user has paid
                            if currentMatch.paidUserIds.contains(participant.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                            } else {
                                // Display an empty circle if not paid
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 8)
                        // FIX: The tap gesture now directly uses participant.id
                        .onTapGesture {
                            // `participant.id` is not optional, so we access it directly.
                            let participantId = participant.id
                            
                            // We call the ViewModel function to toggle the paid status.
                            gameViewModel.markPlayerAsPaid(matchId: currentMatch.id, userId: participantId)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .navigationTitle("Payment Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } else {
                Text("No match details available.")
            }
        }
    }
}
