//
//  DeleteWorkspaceUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 30/07/26.
//

import Foundation

struct DeleteWorkspaceUseCase {
    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) async throws {
        try await repository.deleteWorkspace(id: id)
    }
}
