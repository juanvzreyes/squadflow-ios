//
//  TaskItem.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import CoreTransferable
import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let taskItem = UTType(exportedAs: "com.squadflow.taskitem")
}


enum TaskStatus: String, Codable, CaseIterable {
    case todo = "todo"
    case inProgress = "in_progress"
    case review = "review"
    case done = "done"

    var displayName: String {
        switch self {
        case .todo: "Por hacer"
        case .inProgress: "En progreso"
        case .review: "En revisión"
        case .done: "Completado"
        }
    }

    var color: Color {
        switch self {
        case .todo: .gray
        case .inProgress: .blue
        case .review: .orange
        case .done: .green
        }
    }
}

struct TaskItem: Codable, Identifiable, Hashable, Transferable {
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

    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.id.uuidString)
    }
}
