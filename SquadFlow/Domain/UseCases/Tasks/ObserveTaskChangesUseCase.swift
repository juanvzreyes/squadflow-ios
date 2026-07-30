//
//  ObserveTaskChangesUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

struct ObserveTaskChangesUseCase {
    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func execute(workspaceId: UUID) -> AsyncStream<TaskRealtimeAction> {
        repository.taskChangesStream(for: workspaceId)
    }
}
