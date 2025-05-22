import SwiftUI

struct LearnView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .leading) {
                        Image("RUMPUT")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 361, height: 137)
                            .cornerRadius(20)
                            .clipped()

                        HStack {
                            Spacer()
                            Image("COCK")
                                .resizable()
                                .frame(width: 140, height: 145)
                                .padding(.bottom, 9)
                                .padding(.trailing, 1)
                        }
                        .frame(width: 361, height: 137)

                        VStack(alignment: .leading) {
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
                    .padding(.horizontal)
                    .padding(.top,20)
                    .padding(.bottom,50)

                    

                    Text("The perfect smash tutorials")
                        .font(.headline)
                        .padding(.horizontal)

                    ZStack(alignment: .topLeading) {
                        Color.white
                            .cornerRadius(12)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                LearnCard(title: "How to Smash? 'That Easy' - all about Badminton smash", videoID: "DWsHRZFTqtk", publisher: "full-swing")
                                LearnCard(title: "BEST TIPS TO IMPROVE YOUR SMASH! (SMASH TUTORIAL)", videoID: "Px5XUqcvyXc",publisher: "ViktorAxelsen")
                                LearnCard(title: "5 Drills to Hit The PERFECT BADMINTON SMASH (badminton tutorial)", videoID: "vGD-VU0sAc8",publisher: "Aylex Badminton Academy")
                                LearnCard(title: "Badminton SMASH Tutorial - Improve Your POWER and Timing!", videoID: "H7kpZ9inc10",publisher: "Badminton Insight")
                                LearnCard(title: "Gerakan Simpel Buat Smash Jadi Tajam || Pukulan Langsung Nukik", videoID: "qWJ81DE1LlQ",publisher: "Nathanael Abednego")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(width: 361, height: 161)
                    .padding(.horizontal)

                    Text("The Backhend tutorials")
                        .font(.headline)
                        .padding(.horizontal)

                    ZStack(alignment: .topLeading) {
                        Color.white
                            .cornerRadius(12)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                LearnCard(title: "How To Play A Powerful Backhand Smash - Axelsen Backhand Smash Tutorial - VACADEMY #1", videoID: "bk_PjOmSgzM", publisher: "ViktorAxelsen")
                                LearnCard(title: "How to Play a Backhand Clear, Drop, & Smash (Badminton Tutorial)", videoID: "jCKx70__4ec",publisher: "Aylex Badminton Academy")
                                LearnCard(title: "TUTORIAL BACKHAND. CARA MUDAH BACKHAND BADMINTON.", videoID: "G_wikD0nqAc",publisher: "Fikri fazrin")
                                LearnCard(title: "Tips Menguatkan Pukulan Backhand Yang Lemah", videoID: "-1DJdrYp8KY",publisher: "RIVAISPORT")
                                LearnCard(title: "SUSAH BACKHAND? PERHATIKAN INI BACKHAND JADI MUDAH!", videoID: "DkT1FnxmMk0",publisher: "HR Ten")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(width: 361, height: 161)
                    .padding(.horizontal)
                    
                    Text("Service tutorials")
                        .font(.headline)
                        .padding(.horizontal)

                    ZStack(alignment: .topLeading) {
                        Color.white
                            .cornerRadius(12)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                LearnCard(title: "Tips & trik service pendek untuk pemain ganda, service double badminton training.", videoID: "HdPJd6nvAKM", publisher: "Fikri fazrin")
                                LearnCard(title: "Peraturan Servis Badminton Ganda, cara penerimaan servis #badminton", videoID: "Db7oj_EEVbE",publisher: "BangPar Sports")
                                LearnCard(title: "Badminton Service SECRETS You Need to Know", videoID: "8MlieyvBT9U",publisher: "Aylex Badminton Academy")
                                LearnCard(title: "TEKNIK SERVIS PENDEK DAN SERVIS PANJANG PERMAINAN BULUTANGKIS || Tutorial servis bulutangkis", videoID: "H1JmVtm_LvM",publisher: "randiakbar 18")
                                LearnCard(title: "LATIHAN TEKNIK MENERIMA SERVIS YANG BAIK DAN 100%MUDAH DI PELAJARI 👍", videoID: "_DUcsaXtUS4",publisher: "Nurwahid Ardianto")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(width: 361, height: 161)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
            .navigationTitle("Learn")
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    LearnView()
}
