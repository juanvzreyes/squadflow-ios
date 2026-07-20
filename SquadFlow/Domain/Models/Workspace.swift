//
//  Workspace.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation

struct Workspace: Codable, Identifiable {
    let id: UUID
    let name: String
    let ownerId: UUID?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "owner_id"
        case createdAt = "created_at"
    }
}
