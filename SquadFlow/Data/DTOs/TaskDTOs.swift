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
    }

    struct DeletedRecord: Decodable {
        let id: UUID
    }

    struct MemberResponse: Codable {
        let profiles: Profile
    }
}
