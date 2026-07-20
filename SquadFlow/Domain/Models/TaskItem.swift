//
//  TaskItem.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation

enum TaskStatus: String, Codable {
    case todo = "todo"
    case inProgress = "in_progress"
    case review = "review"
    case done = "done"
}

struct TaskItem: Codable, Identifiable {
    let id: UUID
    let workspaceId: UUID
    let title: String
    let description: String?
    let status: TaskStatus
    let assignedTo: UUID?
    let createdBy: UUID?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case workspaceId = "workspace_id"
        case title
        case description
        case status
        case assignedTo = "assigned_to"
        case createdBy = "created_by"
        case createdAt = "created_at"
    }
}
