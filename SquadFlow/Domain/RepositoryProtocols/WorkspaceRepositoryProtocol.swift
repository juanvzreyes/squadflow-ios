//
//  WorkspaceRepositoryProtocol.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import Foundation

protocol WorkspaceRepositoryProtocol {
    func fetchWorkspaces() async throws -> [Workspace]
    func createWorkspace(name: String) async throws -> Workspace
    func deleteWorkspace(id: UUID) async throws
}
