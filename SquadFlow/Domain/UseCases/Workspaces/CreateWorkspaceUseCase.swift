//
//  CreateWorkspaceUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 30/07/26.
//

import Foundation

struct CreateWorkspaceUseCase {
    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String) async throws -> Workspace {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            throw WorkspaceError.emptyName
        }
        return try await repository.createWorkspace(name: trimmedName)
    }
}

enum WorkspaceError: LocalizedError {
    case emptyName

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "El nombre del espacio no puede estar vacío."
        }
    }
}
