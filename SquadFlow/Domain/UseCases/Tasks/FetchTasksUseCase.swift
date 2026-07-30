//
//  FetchTasksUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

struct FetchTasksUseCase {
    private let taskRepository: TaskRepositoryProtocol
    private let workspaceRepository: WorkspaceRepositoryProtocol

    init(taskRepository: TaskRepositoryProtocol, workspaceRepository: WorkspaceRepositoryProtocol) {
        self.taskRepository = taskRepository
        self.workspaceRepository = workspaceRepository
    }

    func execute(workspaceId: UUID) async throws -> (tasks: [TaskItem], members: [Profile]) {
        async let tasks = taskRepository.fetchTasks(for: workspaceId)
        async let members = workspaceRepository.fetchWorkspaceMembers(workspaceId: workspaceId)
        return try await (tasks: tasks, members: members)
    }
}
