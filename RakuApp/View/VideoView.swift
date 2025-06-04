import SwiftUI

struct VideoView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    GeometryReader { geo in
                        let cardHeight: CGFloat = geo.size.width * 0.38

                        ZStack(alignment: .leading) {
                            Image("RUMPUT")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .cornerRadius(20)
                                .clipped()

                            HStack {
                                Spacer()
                                Image("COCK")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height:90)
                                    .padding(.bottom, 9)
                                    .padding(.trailing, 1)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Check Now!")
                                    .foregroundColor(.white)
                                    .font(.headline)

                                Text("Grip Test")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()

                                Text("Get the opportunity to check your")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Text("posture now")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                        .frame(height: cardHeight)
                    }
                    .frame(height: 160)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 50)

                    Group {
                        SectionView(
                            title: "The perfect smash tutorials",
                            cards: [
                                (
                                    "How to Smash? 'That Easy' - all about Badminton smash",
                                    "DWsHRZFTqtk", "full-swing"
                                ),
                                (
                                    "BEST TIPS TO IMPROVE YOUR SMASH! (SMASH TUTORIAL)",
                                    "Px5XUqcvyXc", "ViktorAxelsen"
                                ),
                                (
                                    "5 Drills to Hit The PERFECT BADMINTON SMASH (badminton tutorial)",
                                    "vGD-VU0sAc8", "Aylex Badminton Academy"
                                ),
                                (
                                    "Badminton SMASH Tutorial - Improve Your POWER and Timing!",
                                    "H7kpZ9inc10", "Badminton Insight"
                                ),
                                (
                                    "Gerakan Simpel Buat Smash Jadi Tajam || Pukulan Langsung Nukik",
                                    "qWJ81DE1LlQ", "Nathanael Abednego"
                                ),
                            ]
                        )

                        SectionView(
                            title: "The Backhend tutorials",
                            cards: [
                                (
                                    "How To Play A Powerful Backhand Smash - Axelsen Backhand Smash Tutorial - VACADEMY #1",
                                    "bk_PjOmSgzM", "ViktorAxelsen"
                                ),
                                (
                                    "How to Play a Backhand Clear, Drop, & Smash (Badminton Tutorial)",
                                    "jCKx70__4ec", "Aylex Badminton Academy"
                                ),
                                (
                                    "TUTORIAL BACKHAND. CARA MUDAH BACKHAND BADMINTON.",
                                    "G_wikD0nqAc", "Fikri fazrin"
                                ),
                                (
                                    "Tips Menguatkan Pukulan Backhand Yang Lemah",
                                    "-1DJdrYp8KY", "RIVAISPORT"
                                ),
                                (
                                    "SUSAH BACKHAND? PERHATIKAN INI BACKHAND JADI MUDAH!",
                                    "DkT1FnxmMk0", "HR Ten"
                                ),
                            ]
                        )

                        SectionView(
                            title: "Service tutorials",
                            cards: [
                                (
                                    "Tips & trik service pendek untuk pemain ganda, service double badminton training.",
                                    "HdPJd6nvAKM", "Fikri fazrin"
                                ),
                                (
                                    "Peraturan Servis Badminton Ganda, cara penerimaan servis #badminton",
                                    "Db7oj_EEVbE", "BangPar Sports"
                                ),
                                (
                                    "Badminton Service SECRETS You Need to Know",
                                    "8MlieyvBT9U", "Aylex Badminton Academy"
                                ),
                                (
                                    "TEKNIK SERVIS PENDEK DAN SERVIS PANJANG PERMAINAN BULUTANGKIS || Tutorial servis bulutangkis",
                                    "H1JmVtm_LvM", "randiakbar 18"
                                ),
                                (
                                    "LATIHAN TEKNIK MENERIMA SERVIS YANG BAIK DAN 100%MUDAH DI PELAJARI 👍",
                                    "_DUcsaXtUS4", "Nurwahid Ardianto"
                                ),
                            ]
                        )
                    }
                }
                .padding(.vertical)
            }
            .background(
                Color(red: 247 / 255, green: 247 / 255, blue: 247 / 255)
            )
            .navigationTitle("Learn")
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct SectionView: View {
    let title: String
    let cards: [(title: String, videoID: String, publisher: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cards, id: \.videoID) { card in
                        LearnCard(
                            title: card.title,
                            videoID: card.videoID,
                            publisher: card.publisher
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 4)
        }
    }
}
#Preview {
    VideoView()
}
