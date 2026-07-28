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

    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func fetchWorkspaces() async {
        isLoading = true
        errorMessage = nil

        do {
            workspaces = try await repository.fetchWorkspaces()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func createWorkspace(name: String) async {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        do {
            let workspace = try await repository.createWorkspace(
                name: trimmedName
            )
            workspaces.insert(workspace, at: 0)
            isShowingCreateForm = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteWorkspace(_ workspace: Workspace) async {
        do {
            try await repository.deleteWorkspace(id: workspace.id)
            workspaces.removeAll { $0.id == workspace.id }
        } catch {
            errorMessage = "Error al eliminar: \(error.localizedDescription)"
        }
    }
}
