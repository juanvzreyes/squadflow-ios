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
    @Environment(DependencyContainer.self) private var container
    @Bindable var viewModel: TaskListViewModel

    @State private var isShowingMembersSheet = false

    var body: some View {
        Group {
            content
        }
        .navigationTitle("Tareas")
        .toolbar { toolbarContent }
        .task { await viewModel.fetchTasks() }
        .task { await viewModel.listenForRealtimeChanges() }
        .sheet(isPresented: $viewModel.isShowingCreateForm) {
            TaskFormView(
                formViewModel: TaskFormViewModel(),
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
        }
        .sheet(item: $viewModel.taskToEdit) { task in
            TaskFormView(
                formViewModel: TaskFormViewModel(),
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
        .sheet(isPresented: $isShowingMembersSheet) {
            WorkspaceMembersView(
                viewModel: WorkspaceMembersViewModel(
                    members: viewModel.members,
                    workspaceId: viewModel.workspaceId,
                    repository: container.workspaceRepository,
                    onMemberAdded: { viewModel.addMember($0) }
                )
            )
            .presentationDetents([.medium, .large])
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
                Task { await router.signOut() }
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isShowingMembersSheet = true
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
