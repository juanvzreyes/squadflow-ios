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
    let creatorName: String
}

enum TaskDisplayMapper {
    static func map(tasks: [TaskItem], members: [Profile]) -> [TaskDisplayInfo] {
        let memberLookup = Dictionary(
            uniqueKeysWithValues: members.map { ($0.id, $0) }
        )

        return tasks.map { task in
            let assigneeName =
                task.assignedTo
                .flatMap { memberLookup[$0] }
                .flatMap { $0.username ?? $0.fullName }
                ?? "Sin asignar"

            let creatorName =
                task.createdBy
                .flatMap { memberLookup[$0] }
                .flatMap { $0.username ?? $0.fullName }
                ?? "Desconocido"

            return TaskDisplayInfo(
                task: task,
                assigneeName: assigneeName,
                creatorName: creatorName
            )
        }
    }
}
