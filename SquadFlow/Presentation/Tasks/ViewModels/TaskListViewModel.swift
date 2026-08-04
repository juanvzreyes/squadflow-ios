//
//  TaskListViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class TaskListViewModel {
    var tasks: [TaskItem] = []
    var members: [Profile] = []
    var displayItems: [TaskDisplayInfo] = []
    var isLoading = false
    var errorMessage: String?
    var isShowingCreateForm = false
    var taskToEdit: TaskItem?
    let workspaceId: UUID

    private let fetchTasksUseCase: FetchTasksUseCase
    private let createTaskUseCase: CreateTaskUseCase
    private let updateTaskUseCase: UpdateTaskUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    private let observeTaskChangesUseCase: ObserveTaskChangesUseCase

    init(taskRepository: TaskRepositoryProtocol, workspaceRepository: WorkspaceRepositoryProtocol, workspaceId: UUID) {
        self.fetchTasksUseCase = FetchTasksUseCase(taskRepository: taskRepository, workspaceRepository: workspaceRepository)
        self.createTaskUseCase = CreateTaskUseCase(repository: taskRepository)
        self.updateTaskUseCase = UpdateTaskUseCase(repository: taskRepository)
        self.deleteTaskUseCase = DeleteTaskUseCase(repository: taskRepository)
        self.observeTaskChangesUseCase = ObserveTaskChangesUseCase(repository: taskRepository)
        self.workspaceId = workspaceId
    }

    // MARK: - Display Mapping

    private func refreshDisplayItems() {
        displayItems = TaskDisplayMapper.map(tasks: tasks, members: members)
    }

    // MARK: - CRUD Operations

    func fetchTasks() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await fetchTasksUseCase.execute(workspaceId: workspaceId)
            tasks = result.tasks
            members = result.members
            refreshDisplayItems()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func createTask(title: String, description: String?, status: TaskStatus, assignedTo: UUID?) async {
        do {
            let newTask = try await createTaskUseCase.execute(
                workspaceId: workspaceId,
                title: title,
                description: description,
                status: status,
                assignedTo: assignedTo
            )
            tasks.insert(newTask, at: 0)
            refreshDisplayItems()
            isShowingCreateForm = false
        } catch {
            errorMessage = "Error al crear la tarea: \(error.localizedDescription)"
        }
    }

    func updateTask(taskId: UUID, title: String, description: String?, status: TaskStatus, assignedTo: UUID?) async {
        do {
            let updatedTask = try await updateTaskUseCase.execute(
                taskId: taskId,
                title: title,
                description: description,
                status: status,
                assignedTo: assignedTo
            )
            if let index = tasks.firstIndex(where: { $0.id == taskId }) {
                tasks[index] = updatedTask
            }
            refreshDisplayItems()
            taskToEdit = nil
        } catch {
            errorMessage = "Error al actualizar: \(error.localizedDescription)"
        }
    }

    func deleteTask(task: TaskItem) async {
        do {
            try await deleteTaskUseCase.execute(taskId: task.id)
            tasks.removeAll { $0.id == task.id }
            refreshDisplayItems()
        } catch {
            errorMessage = "Error al eliminar: \(error.localizedDescription)"
        }
    }

    // MARK: - Members

    func addMember(_ member: Profile) {
        members.append(member)
        refreshDisplayItems()
    }

    // MARK: - Realtime

    func listenForRealtimeChanges() async {
        let stream = observeTaskChangesUseCase.execute(workspaceId: workspaceId)

        for await action in stream {
            withAnimation {
                switch action {
                case .insert(let task):
                    if !self.tasks.contains(where: { $0.id == task.id }) {
                        self.tasks.insert(task, at: 0)
                    }

                case .update(let task):
                    if let index = self.tasks.firstIndex(where: {
                        $0.id == task.id
                    }) {
                        self.tasks[index] = task
                    }

                case .delete(let taskId):
                    self.tasks.removeAll { $0.id == taskId }
                }
                self.refreshDisplayItems()
            }
        }
    }
}
