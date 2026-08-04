//
//  RemoveMemberFromWorkspaceUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import Foundation

struct RemoveMemberFromWorkspaceUseCase {
    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(workspaceId: UUID, profileId: UUID) async throws {
        try await repository.removeMemberFromWorkspace(
            workspaceId: workspaceId,
            profileId: profileId
        )
    }
}
