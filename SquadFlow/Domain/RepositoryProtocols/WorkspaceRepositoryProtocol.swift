//
//  WorkspaceRepositoryProtocol.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import Foundation

protocol WorkspaceRepositoryProtocol: Sendable {
    func fetchWorkspaces() async throws -> [Workspace]
    func createWorkspace(name: String) async throws -> Workspace
    func deleteWorkspace(id: UUID) async throws
    func fetchWorkspaceMembers(workspaceId: UUID) async throws -> [Profile]
    func inviteUserByUsername(workspaceId: UUID, username: String) async throws -> Profile
    func searchProfiles(query: String) async throws -> [Profile]
    func addMemberToWorkspace(workspaceId: UUID, profileId: UUID) async throws
    func removeMemberFromWorkspace(workspaceId: UUID, profileId: UUID) async throws
}
