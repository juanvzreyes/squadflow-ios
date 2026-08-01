//
//  WorkspaceRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import Foundation
import Supabase

final class WorkspaceRepository: WorkspaceRepositoryProtocol {
    private let client = SupabaseManager.shared.client

    func fetchWorkspaces() async throws -> [Workspace] {
        return try await client
            .from("workspaces")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func createWorkspace(name: String) async throws -> Workspace {
        let session = try await client.auth.session
        let userId = session.user.id

        let payload = WorkspaceDTOs.CreateWorkspacePayload(
            name: name,
            owner_id: userId
        )

        let newWorkspace: Workspace = try await client
            .from("workspaces")
            .insert(payload)
            .select()
            .single()
            .execute()
            .value

        let memberPayload = WorkspaceDTOs.CreateMemberPayload(
            workspace_id: newWorkspace.id,
            profile_id: userId,
            role: "owner"
        )

        try await client
            .from("workspace_members")
            .insert(memberPayload)
            .execute()

        return newWorkspace
    }

    func deleteWorkspace(id: UUID) async throws {
        try await client
            .from("workspaces")
            .delete()
            .eq("id", value: id)
            .execute()
    }

    func fetchWorkspaceMembers(workspaceId: UUID) async throws -> [Profile] {
        let response: [WorkspaceDTOs.MemberResponse] = try await client
            .from("workspace_members")
            .select("profiles(id, username, full_name)")
            .eq("workspace_id", value: workspaceId)
            .execute()
            .value

        return response.map { $0.profiles }
    }
}
