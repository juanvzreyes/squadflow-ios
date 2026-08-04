//
//  CreateMemberInvitationUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import Foundation

enum InvitationError: LocalizedError {
    case emptyUsername
    case alreadyMember
    case userNotFound(String)

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            "El nombre de usuario no puede estar vacío."
        case .alreadyMember:
            "Este usuario ya está en el equipo."
        case .userNotFound(let username):
            "No se encontró ningún usuario llamado \(username)."
        }
    }
}

struct CreateMemberInvitationUseCase {
    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(workspaceId: UUID, profile: Profile, currentMembers: [Profile]) async throws {
        if currentMembers.contains(where: { $0.id == profile.id }) {
            throw InvitationError.alreadyMember
        }

        try await repository.addMemberToWorkspace(
            workspaceId: workspaceId,
            profileId: profile.id
        )
    }

    func execute(workspaceId: UUID, username: String, currentMembers: [Profile]) async throws -> Profile {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmed.isEmpty else {
            throw InvitationError.emptyUsername
        }

        if currentMembers.contains(where: { $0.username?.lowercased() == trimmed }) {
            throw InvitationError.alreadyMember
        }

        guard let profile = try await repository.getProfileByUsername(username: trimmed) else {
            throw InvitationError.userNotFound(username)
        }

        try await repository.addMemberToWorkspace(
            workspaceId: workspaceId,
            profileId: profile.id
        )
        
        return profile
    }
}
