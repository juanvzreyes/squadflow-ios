//
//  UpdateTaskUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

struct UpdateTaskUseCase {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func execute(taskId: UUID, title: String, description: String?, status: TaskStatus, assignedTo: UUID?) async throws -> TaskItem {
        try await repository.updateTask(
            taskId: taskId,
            title: title,
            description: description,
            status: status,
            assignedTo: assignedTo
        )
    }
}
