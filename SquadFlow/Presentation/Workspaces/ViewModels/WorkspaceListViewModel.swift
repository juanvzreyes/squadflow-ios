//
//  WorkspaceListViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class WorkspaceListViewModel {
    var workspaces: [Workspace] = []
    var isLoading = false
    var errorMessage: String?

    var isShowingCreateForm = false
    var newWorkspaceName = ""
    var isCreating = false

    private let fetchWorkspacesUseCase: FetchWorkspacesUseCase
    private let createWorkspaceUseCase: CreateWorkspaceUseCase
    private let deleteWorkspaceUseCase: DeleteWorkspaceUseCase

    init(repository: WorkspaceRepositoryProtocol) {
        self.fetchWorkspacesUseCase = FetchWorkspacesUseCase(repository: repository)
        self.createWorkspaceUseCase = CreateWorkspaceUseCase(repository: repository)
        self.deleteWorkspaceUseCase = DeleteWorkspaceUseCase(repository: repository)
    }

    func fetchWorkspaces() async {
        isLoading = true
        errorMessage = nil

        do {
            workspaces = try await fetchWorkspacesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func createWorkspace(name: String) async {
        do {
            let workspace = try await createWorkspaceUseCase.execute(name: name)
            workspaces.insert(workspace, at: 0)
            isShowingCreateForm = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteWorkspace(_ workspace: Workspace) async {
        do {
            try await deleteWorkspaceUseCase.execute(id: workspace.id)
            workspaces.removeAll { $0.id == workspace.id }
        } catch {
            errorMessage = "Error al eliminar: \(error.localizedDescription)"
        }
    }
}
