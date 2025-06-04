    //
//  LeaderboardViewModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    @Published var leaderboardM: [LeaderboardModel] = []
    
    // Properti currentUserID dihapus untuk sementara

    init() {
        // Secara otomatis mengambil dan memproses pengguna saat ViewModel dibuat
        fetchAndProcessUsers()
    }

    // Fungsi untuk mengubah string pengalaman menjadi poin
    // Di sinilah logika spesifik game/aplikasi Anda untuk skor akan ditempatkan.
    private func points(for experience: String) -> Int {
        switch experience.lowercased() {
        case "beginner":
            return 100
        case "intermediate":
            return 500
        case "advanced":
            return 1000
        case "expert":
            return 2000
        default:
            return 50 // Poin default untuk level pengalaman lainnya
        }
    }

    // Menghasilkan data MyUser dummy, memprosesnya menjadi item LeaderboardEntry
    func fetchAndProcessUsers() {
        // 1. Definisikan data MyUser dummy Anda
        let users: [MyUser] = [
            MyUser(id: "user1", email: "gabriella@example.com", name: "Gabriella", experience: "beginner"),
            MyUser(id: "user2", email: "kezia@example.com", name: "Kezia Allen", experience: "advanced"),
            MyUser(id: "user3", email: "ardi@example.com", name: "Ardi", experience: "intermediate"),
            MyUser(id: "user4", email: "josua@example.com", name: "Josua", experience: "expert"),
            MyUser(id: "user5", email: "surya@example.com", name: "Surya", experience: "beginner"),
            MyUser(id: "user6", name: "Test User 6", experience: "beginner"),
            MyUser(id: "user7", name: "Test User 7", experience: "intermediate"),
            MyUser(id: "user8", name: "Another Player", experience: "expert"),
            MyUser(id: "user9", name: "Player Nine", experience: "advanced"),
            MyUser(id: "user10", name: "Tenth Competitor", experience: "beginner"),
        ]

        // 2. Ubah objek MyUser menjadi struktur sementara yang menyertakan poin
        var usersWithPoints = users.map { user in
            (user: user, points: points(for: user.experience))
        }

        // 3. Urutkan pengguna berdasarkan poin secara menurun untuk menentukan peringkat mereka
        usersWithPoints.sort { $0.points > $1.points }

        // 4. Buat objek LeaderboardEntry akhir, termasuk peringkat dan status isCurrentUser (selalu false)
        self.leaderboardM = usersWithPoints.enumerated().map { (index, userPointPair) in
            let rank = index + 1 // Peringkat dimulai dari 1
            let user = userPointPair.user
            let points = userPointPair.points
            return LeaderboardModel(
                id: user.id,
                rank: rank,
                name: user.name,
                points: points,
                isCurrentUser: false // Dibuat false untuk semua entri
            )
        }
    }
}
