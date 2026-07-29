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

    func taskChangesStream(for workspaceId: UUID) -> AsyncStream<TaskRealtimeAction> {
        AsyncStream { continuation in
            let channel = client.channel("tasks-\(workspaceId.uuidString)")

            let changeStream = channel.postgresChange(
                AnyAction.self,
                schema: "public",
                table: "tasks",
                filter: .eq("workspace_id", value: workspaceId)
            )

            let listenerTask = Task {
                try await channel.subscribeWithError()

                for await change in changeStream {
                    switch change {
                    case .insert(let action):
                        if let newTask = try? action.record.decode(as: TaskItem.self) {
                            continuation.yield(.insert(newTask))
                        }

                    case .update(let action):
                        if let updatedTask = try? action.record.decode(as: TaskItem.self) {
                            continuation.yield(.update(updatedTask))
                        }

                    case .delete(let action):
                        struct DeletedRecord: Decodable {
                            let id: UUID
                        }

                        if let deleted = try? action.oldRecord.decode(as: DeletedRecord.self) {
                            continuation.yield(.delete(deleted.id))
                        }
                    }
                }
            }

            continuation.onTermination = { _ in
                listenerTask.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }
}
