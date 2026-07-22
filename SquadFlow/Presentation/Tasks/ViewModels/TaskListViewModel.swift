//
//  TaskListViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import Foundation

@MainActor
@Observable
final class TaskListViewModel {
    var tasks: [TaskItem] = []
    var isLoading = false
    var errorMessage: String?
    var isShowingCreateForm = false
    var taskToEdit: TaskItem?

    private let repository: TaskRepositoryProtocol
    private let workspaceId: UUID

    init(repository: TaskRepositoryProtocol, workspaceId: UUID) {
        self.repository = repository
        self.workspaceId = workspaceId
    }

    func fetchTasks() async {
        isLoading = true
        errorMessage = nil
        do {
            tasks = try await repository.fetchTasks(for: workspaceId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func createTask(title: String, description: String?, status: TaskStatus) async {
        do {
            let newTask = try await repository.createTask(
                workspaceId: workspaceId,
                title: title,
                description: description,
                status: status
            )
            tasks.insert(newTask, at: 0)
            isShowingCreateForm = false
        } catch {
            errorMessage = "Error al crear la tarea: \(error.localizedDescription)"
        }
    }

    func updateTask(taskId: UUID, title: String, description: String?, status: TaskStatus) async {
        do {
            let updatedTask = try await repository.updateTask(
                taskId: taskId,
                title: title,
                description: description,
                status: status
            )
            if let index = tasks.firstIndex(where: { $0.id == taskId }) {
                tasks[index] = updatedTask
            }
            taskToEdit = nil
        } catch {
            errorMessage = "Error al actualizar: \(error.localizedDescription)"
        }
    }

    func deleteTask(task: TaskItem) async {
        do {
            try await repository.deleteTask(taskId: task.id)
            tasks.removeAll { $0.id == task.id }
        } catch {
            errorMessage = "Error al eliminar: \(error.localizedDescription)"
        }
    }
}
