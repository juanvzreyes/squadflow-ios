//
//  TaskListView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var viewModel: TaskListViewModel
    let authRepository: AuthRepositoryProtocol

    var body: some View {
        Group {
            content
        }
        .navigationTitle("Tareas")
        .toolbar { toolbarContent }
        .task { await viewModel.fetchTasks() }
        .task { await viewModel.listenForRealtimeChanges() }
        .sheet(isPresented: $viewModel.isShowingCreateForm) {
            TaskFormView(taskToEdit: nil) {
                title,
                description,
                status in
                await viewModel.createTask(
                    title: title,
                    description: description,
                    status: status
                )
            }
        }
        .sheet(item: $viewModel.taskToEdit) { task in
            TaskFormView(taskToEdit: task) {
                title,
                description,
                status in
                await viewModel.updateTask(
                    taskId: task.id,
                    title: title,
                    description: description,
                    status: status
                )
            }
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("Entendido", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task { await viewModel.fetchTasks() }
            }
        }
    }

    // MARK: - Estados

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.tasks.isEmpty {
            LoadingStateView()
        } else if let error = viewModel.errorMessage {
            ErrorStateView(message: error) {
                Task { await viewModel.fetchTasks() }
            }
        } else if viewModel.tasks.isEmpty {
            EmptyStateView()
        } else {
            TaskListContent(
                tasks: viewModel.tasks,
                onTap: { viewModel.taskToEdit = $0 },
                onDelete: { task in
                    Task { await viewModel.deleteTask(task: task) }
                }
            )
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                Task { try? await authRepository.signOut() }
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.isShowingCreateForm = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
