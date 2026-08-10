//
//  TaskDTOs.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

enum TaskDTOs {
    struct CreatePayload: Encodable {
        let workspace_id: UUID
        let title: String
        let description: String?
        let status: String
        let created_by: UUID
        let assigned_to: UUID?
    }

    struct UpdatePayload: Encodable {
        let title: String
        let description: String?
        let status: String
        let assigned_to: UUID?

        enum CodingKeys: String, CodingKey {
            case title
            case description
            case status
            case assigned_to
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(description, forKey: .description)
            try container.encode(status, forKey: .status)
            try container.encode(assigned_to, forKey: .assigned_to)
        }
    }

    struct DeletedRecord: Decodable {
        let id: UUID
    }
}
