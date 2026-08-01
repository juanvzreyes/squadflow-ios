//
//  FetchWorkspacesUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 30/07/26.
//

import Foundation

struct FetchWorkspacesUseCase {
    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Workspace] {
        try await repository.fetchWorkspaces()
    }
}
