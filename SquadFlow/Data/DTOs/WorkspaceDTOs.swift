//
//  WorkspaceDTOs.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 30/07/26.
//

import Foundation

enum WorkspaceDTOs {

    struct CreateWorkspacePayload: Encodable {
        let name: String
        let owner_id: UUID
    }

    struct CreateMemberPayload: Encodable {
        let workspace_id: UUID
        let profile_id: UUID
        let role: String
    }

    struct MemberResponse: Codable {
        let profiles: Profile
    }
}
