//
//  WorkspaceListView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct WorkspaceListView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DependencyContainer.self) private var container
    @Bindable var viewModel: WorkspaceListViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .navigationTitle("Espacios de Trabajo")
            .toolbar { toolbarContent }
            .task { await viewModel.fetchWorkspaces() }
            .navigationDestination(for: Workspace.self) { workspace in
                let taskVM = TaskListViewModel(
                    taskRepository: container.taskRepository,
                    workspaceRepository: container.workspaceRepository,
                    workspaceId: workspace.id
                )
                TaskListView(viewModel: taskVM)
            }
            .sheet(isPresented: $viewModel.isShowingCreateForm) {
                WorkspaceFormView { name in
                    await viewModel.createWorkspace(name: name)
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
        }
    }

    // MARK: - Estados

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.workspaces.isEmpty {
            LoadingStateView()
        } else if let error = viewModel.errorMessage {
            ErrorStateView(message: error) {
                Task { await viewModel.fetchWorkspaces() }
            }
        } else if viewModel.workspaces.isEmpty {
            EmptyStateView(
                title: "Sin equipos",
                systemImage: "briefcase.fill",
                description: "Crea un espacio de trabajo para comenzar"
            )
        } else {
            WorkspaceListContent(workspaces: viewModel.workspaces) { workspace in
                Task {
                    await viewModel.deleteWorkspace(workspace)
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                Task { await router.signOut() }
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
