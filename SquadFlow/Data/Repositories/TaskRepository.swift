//
//  TaskRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import Foundation
import Supabase

final class TaskRepository: TaskRepositoryProtocol {
    private let client = SupabaseManager.shared.client

    func fetchTasks(for workspaceId: UUID) async throws -> [TaskItem] {
        try await client
            .from("tasks")
            .select()
            .eq("workspace_id", value: workspaceId)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func createTask(workspaceId: UUID, title: String, description: String?, status: TaskStatus) async throws -> TaskItem {
        struct CreatePayload: Encodable {
            let workspace_id: UUID
            let title: String
            let description: String?
            let status: String
        }

        let payload = CreatePayload(
            workspace_id: workspaceId,
            title: title,
            description: description,
            status: status.rawValue
        )

        return try await client
            .from("tasks")
            .insert(payload)
            .select()
            .single()
            .execute()
            .value
    }

    func updateTask(taskId: UUID, title: String, description: String?, status: TaskStatus) async throws -> TaskItem {
        struct UpdatePayload: Encodable {
            let title: String
            let description: String?
            let status: String
        }

        let payload = UpdatePayload(
            title: title,
            description: description,
            status: status.rawValue
        )

        return try await client
            .from("tasks")
            .update(payload)
            .eq("id", value: taskId)
            .select()
            .single()
            .execute()
            .value
    }

    func deleteTask(taskId: UUID) async throws {
        try await client
            .from("tasks")
            .delete()
            .eq("id", value: taskId)
            .execute()
    }
}
