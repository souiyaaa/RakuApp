import Foundation

struct Match: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var date: Date
    var courtCost: Double
    var players: [MyUser]
    var games: [Game]
    var paidUserIds: [String]
    var location: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, date, courtCost, players, games, paidUserIds, location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Untitled"
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""

        // Handle date decoding (timestamp from Firebase)
        if let timestamp = try? container.decode(Double.self, forKey: .date) {
            date = Date(timeIntervalSince1970: timestamp)
        } else {
            date = Date()
        }

        courtCost = try container.decodeIfPresent(Double.self, forKey: .courtCost) ?? 0.0
        players = try container.decodeIfPresent([MyUser].self, forKey: .players) ?? []
        games = try container.decodeIfPresent([Game].self, forKey: .games) ?? []
        paidUserIds = try container.decodeIfPresent([String].self, forKey: .paidUserIds) ?? []
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? "Unknown"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(date.timeIntervalSince1970, forKey: .date)
        try container.encode(courtCost, forKey: .courtCost)
        try container.encode(players, forKey: .players)
        try container.encode(games, forKey: .games)
        try container.encode(paidUserIds, forKey: .paidUserIds)
        try container.encode(location, forKey: .location)
    }

    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        date: Date,
        courtCost: Double,
        players: [MyUser],
        games: [Game],
        paidUserIds: [String],
        location: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.courtCost = courtCost
        self.players = players
        self.games = games
        self.paidUserIds = paidUserIds
        self.location = location
    }
}
