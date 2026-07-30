//
//  CreateTaskUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

struct CreateTaskUseCase {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func execute(workspaceId: UUID, title: String, description: String?, status: TaskStatus, assignedTo: UUID?) async throws -> TaskItem {
        try await repository.createTask(
            workspaceId: workspaceId,
            title: title,
            description: description,
            status: status,
            assignedTo: assignedTo
        )
    }
}
