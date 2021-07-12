// This file was generated from JSON Schema using quicktype, do not modify it directly.

import Foundation

// MARK: - HearingScore

struct HearingScore: Codable {
    let score: Int?
    let rounds: [Round]?
}

// MARK: - Round

struct Round: Codable {
    let difficulty: Int?
    let tripletPlayed, tripletAnswered: String?

    enum CodingKeys: String, CodingKey {
        case difficulty
        case tripletPlayed = "triplet_played"
        case tripletAnswered = "triplet_answered"
    }
}

