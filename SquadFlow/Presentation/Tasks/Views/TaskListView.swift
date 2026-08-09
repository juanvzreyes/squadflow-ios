//
//  TaskListView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(AppRouter.self) private var router
    @Bindable var viewModel: TaskListViewModel

    var body: some View {
        Group {
            content
        }
        .navigationTitle("Tareas")
        .toolbar { toolbarContent }
        .task { await viewModel.fetchTasks() }
        .task { await viewModel.listenForRealtimeChanges() }
        .sheet(isPresented: $viewModel.isShowingCreateForm) {
            let formVM = viewModel.createFormViewModel
            TaskFormView(
                formViewModel: formVM,
                taskToEdit: nil,
                members: viewModel.members
            ) { title, description, status, assignedTo in
                await viewModel.createTask(
                    title: title,
                    description: description,
                    status: status,
                    assignedTo: assignedTo
                )
            }
            .onDisappear { viewModel.createFormViewModel.reset() }
        }
        .sheet(item: $viewModel.taskToEdit) { task in
            TaskFormView(
                formViewModel: viewModel.editFormViewModel,
                taskToEdit: task,
                members: viewModel.members
            ) { title, description, status, assignedTo in
                await viewModel.updateTask(
                    taskId: task.id,
                    title: title,
                    description: description,
                    status: status,
                    assignedTo: assignedTo
                )
            }
        }
        .sheet(isPresented: $viewModel.isShowingMembersSheet) {
            if let membersVM = viewModel.membersViewModel {
                WorkspaceMembersView(viewModel: membersVM)
                    .presentationDetents([.medium, .large])
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

    // MARK: - States

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
                displayItems: viewModel.displayItems,
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
                viewModel.prepareMembersViewModel(currentUserId: router.currentUserId)
                viewModel.isShowingMembersSheet = true
            } label: {
                Image(systemName: "person.2.badge.plus")
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
