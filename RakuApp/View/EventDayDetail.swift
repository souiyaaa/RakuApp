
import SwiftUI

struct EventInvitationView: View {
    var matches: [Match]
    let currentUser: MyUser

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if matches.isEmpty {
                    Text("No events for this day.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(matches) { match in
                        EventRowView(match: match, currentUser: currentUser)
                    }
                }
            }
            .padding()
        }
    }
}



struct EventRowView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    let match: Match
    let currentUser: MyUser

    @State private var showingSplitPayment = false
    @State private var showingEditEvent = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(match.date, formatter: timeFormatter)
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray5))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                // Selalu tampilkan "YOU ARE INVITED" dengan Quick Match
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [.pink, .orange, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 140)

                    VStack(spacing: 12) {
                        Text("YOU ARE\nINVITED")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

//                        NavigationLink(destination: MatchDetailView()) {
//                            HStack {
//                                Image(systemName: "bolt.fill")
//                                Text("Quick Match")
//                                    .fontWeight(.semibold)
//                            }
//                            .font(.callout)
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//                            .background(Color.white.opacity(0.3))
//                            .foregroundColor(.white)
//                            .cornerRadius(20)
//                        }
                    }
                    .padding()

                    if match.paidUserIds.contains(currentUser.id ?? "") {
                        HStack {
                            Spacer()
                            VStack {
                                Label("Going", systemImage: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(6)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                Spacer()
                            }
                        }
                        .padding(10)
                    }
                }

                // Info Event
                VStack(alignment: .leading, spacing: 2) {
                    Text(match.name)
                        .fontWeight(.semibold)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(match.location)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }

                // Participants
                HStack(spacing: 6) {
                    HStack(spacing: -10) {
                        ForEach(match.players.prefix(3), id: \.id) { _ in
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    Text("\(match.players.count) Participants")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Tombol Aksi
                HStack(spacing: 10) {
                    Button("Get Direction") {}
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                    Button("Payments info") {
                        gameViewModel.setCurrentMatch(matchId: match.id)
                        showingSplitPayment = true
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .sheet(isPresented: $showingSplitPayment) {
                        SplitPayment()
                    }

                    Button("Edit Event") {
                        gameViewModel.setCurrentMatch(matchId: match.id)
                        showingEditEvent = true
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .sheet(isPresented: $showingEditEvent) {
                        EditEventView()
                    }
                }

                Divider()
            }
        }
    }

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
