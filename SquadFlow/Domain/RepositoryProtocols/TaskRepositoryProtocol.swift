//
//  TaskRepositoryProtocol.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import Foundation

enum TaskRealtimeAction {
    case insert(TaskItem)
    case update(TaskItem)
    case delete(UUID)
}

protocol TaskRepositoryProtocol {
    func fetchTasks(for workspaceId: UUID) async throws -> [TaskItem]
    func createTask(workspaceId: UUID, title: String, description: String?, status: TaskStatus) async throws -> TaskItem
    func updateTask(taskId: UUID, title: String, description: String?,status: TaskStatus) async throws -> TaskItem
    func deleteTask(taskId: UUID) async throws

    func taskChangesStream(for workspaceId: UUID) -> AsyncStream<TaskRealtimeAction>
}
