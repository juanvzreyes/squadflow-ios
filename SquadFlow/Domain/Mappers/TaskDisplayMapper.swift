//
//  TaskDisplayMapper.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

struct TaskDisplayInfo {
    let task: TaskItem
    let assigneeName: String
    let assigneeAvatarUrl: String?
    let creatorName: String
    let creatorAvatarUrl: String?
}

enum TaskDisplayMapper {
    static func map(tasks: [TaskItem], members: [Profile]) -> [TaskDisplayInfo] {
        let memberLookup = Dictionary(
            uniqueKeysWithValues: members.map { ($0.id, $0) }
        )

        return tasks.map { task in
            let assignee = task.assignedTo.flatMap { memberLookup[$0] }
            let assigneeName = assignee
                .flatMap { $0.username ?? $0.fullName }
                ?? "Sin asignar"
            let assigneeAvatarUrl = assignee?.avatarUrl

            let creator = task.createdBy.flatMap { memberLookup[$0] }
            let creatorName = creator
                .flatMap { $0.username ?? $0.fullName }
                ?? "Desconocido"
            let creatorAvatarUrl = creator?.avatarUrl

            return TaskDisplayInfo(
                task: task,
                assigneeName: assigneeName,
                assigneeAvatarUrl: assigneeAvatarUrl,
                creatorName: creatorName,
                creatorAvatarUrl: creatorAvatarUrl
            )
        }
    }
}
