//
//  WorkspaceListView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct WorkspaceListView: View {
    @Bindable var viewModel: WorkspaceListViewModel
    let authRepository: AuthRepositoryProtocol

    var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .navigationTitle("Espacios de Trabajo")
            .toolbar { toolbarContent }
            .task { await viewModel.fetchWorkspaces() }
            .navigationDestination(for: Workspace.self) { workspace in
                let taskRepo = TaskRepository()
                let taskVM = TaskListViewModel(
                    repository: taskRepo,
                    workspaceId: workspace.id
                )
                TaskListView(viewModel: taskVM, authRepository: authRepository)
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
            EmptyStateView()
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
