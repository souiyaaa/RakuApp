
import SwiftUI

struct EditEventView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedDate = Date()
    @State private var cost: String = ""
    @State private var eventName: String = ""
    @State private var description: String = ""
    
    // State untuk menampilkan sheet AddPlayersView
    @State private var showingAddPlayers = false

    var body: some View {
        NavigationView {
            // Pastikan ada match yang sedang diedit
            if let currentMatch = gameViewModel.currentMatch {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Section untuk Jadwal
                        VStack(alignment: .leading) {
                            Text("Reschedule")
                                .font(.headline)
                            DatePicker("Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact) // Dibuat lebih ringkas
                        }

                        Divider()

                        // Section untuk Peserta
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Participants")
                                .font(.headline)
                            
                            HStack {
                                HStack(spacing: -10) {
                                    ForEach(currentMatch.players.prefix(5), id: \.id) { player in
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Text("\(currentMatch.players.count) Participants")
                                    .font(.subheadline)
                                Spacer()
                                Button("Manage Players") {
                                    showingAddPlayers = true
                                }
                                .font(.subheadline)
                            }
                        }

                        Divider()
                        
                        // Section untuk Detail Event
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Event Details")
                                .font(.headline)
                            TextField("Event Name", text: $eventName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Description", text: $description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Cost of Court", text: $cost)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                }
                .navigationTitle("Edit Event")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Tombol untuk batal
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    // Tombol untuk simpan perubahan
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if var match = gameViewModel.currentMatch {
                                match.name = eventName
                                match.description = description
                                if let newCost = Double(cost) {
                                    match.courtCost = newCost
                                }
                                match.date = selectedDate
                                gameViewModel.updateMatch(match)
                                dismiss()
                            }
                        }
                        .fontWeight(.bold)
                    }
                }
                // Mengisi state dengan data dari match saat view pertama kali muncul
                .onAppear {
                    eventName = currentMatch.name
                    description = currentMatch.description
                    cost = String(format: "%.0f", currentMatch.courtCost)
                    selectedDate = currentMatch.date
                }
                // Menampilkan sheet untuk menambah/mengurangi pemain
                .sheet(isPresented: $showingAddPlayers) {
                    // AddPlayersView sekarang menerima binding ke `showingAddPlayers` untuk menutup dirinya sendiri
                    AddPlayersView(matchId: currentMatch.id, showingAddPlayers: $showingAddPlayers)
                }
            } else {
                Text("No match selected for editing.")
            }
        }
    }
}

// --- Perbaikan pada AddPlayersView ---
struct AddPlayersView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss // Untuk menutup sheet
    
    let matchId: String
    @Binding var showingAddPlayers: Bool // Binding untuk kontrol sheet

    @State private var searchText = ""
    @State private var selectedPlayerIDs: Set<String> = []

    // Filtered users
    var filteredUsers: [MyUser] {
        if searchText.isEmpty {
            return userViewModel.myUserDatas
        } else {
            return userViewModel.myUserDatas.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search Players")
                List(filteredUsers) { user in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text(user.name)
                            Text(user.experience)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        // Tampilkan checkmark jika pemain dipilih
                        if selectedPlayerIDs.contains(user.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    // FIX: Logika untuk memilih/batal memilih pemain diaktifkan
                    .onTapGesture {
                        if selectedPlayerIDs.contains(user.id) {
                            selectedPlayerIDs.remove(user.id)
                        } else {
                            selectedPlayerIDs.insert(user.id)
                        }
                    }
                }
            }
            .navigationTitle("Manage Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddPlayers = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // FIX: Logika untuk menyimpan pemain yang dipilih
                        // 1. Dapatkan objek MyUser lengkap dari ID yang dipilih
                        let selectedPlayers = userViewModel.myUserDatas.filter { selectedPlayerIDs.contains($0.id) }
                        
                        // 2. Update match dengan daftar pemain yang baru
                        if var match = gameViewModel.currentMatch {
                            match.players = selectedPlayers
                            gameViewModel.updateMatch(match)
                        }
                        
                        // 3. Tutup sheet
                        showingAddPlayers = false
                    }
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                // Pre-select players yang sudah ada di dalam match saat ini
                if let currentPlayers = gameViewModel.currentMatch?.players {
                    selectedPlayerIDs = Set(currentPlayers.map { $0.id })
                }
            }
        }
    }
}

// SearchBar tetap sama
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.horizontal)
    }
}
