//
//  ProfileDTOs.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation

enum ProfileDTOs {
    struct UpdatePayload: Encodable {
        let username: String
        let full_name: String
        let avatar_url: String?
        let updated_at: Date

        enum CodingKeys: String, CodingKey {
            case username
            case full_name
            case avatar_url
            case updated_at
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(username, forKey: .username)
            try container.encode(full_name, forKey: .full_name)
            try container.encode(avatar_url, forKey: .avatar_url)
            try container.encode(updated_at, forKey: .updated_at)
        }
    }
}
