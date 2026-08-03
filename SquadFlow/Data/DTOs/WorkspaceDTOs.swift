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

    enum WorkspaceRole: String, Encodable {
        case owner
        case member

        var displayName: String {
            switch self {
            case .owner:
                return "Propietario"
            case .member:
                return "Miembro"
            }
        }
    }

    struct CreateMemberPayload: Encodable {
        let workspace_id: UUID
        let profile_id: UUID
        let role: WorkspaceRole
    }

    struct MemberResponse: Codable {
        let profiles: Profile
    }
}
