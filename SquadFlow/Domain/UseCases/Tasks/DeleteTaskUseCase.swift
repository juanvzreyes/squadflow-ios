//
//  DeleteTaskUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

struct DeleteTaskUseCase {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func execute(taskId: UUID) async throws {
        try await repository.deleteTask(taskId: taskId)
    }
}
