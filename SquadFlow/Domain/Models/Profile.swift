//
//  Profile.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation

struct Profile: Codable, Identifiable {
    let id: UUID
    let username: String?
    let fullName: String?
    let avatarUrl: String?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case updatedAt = "updated_at"
    }
}
