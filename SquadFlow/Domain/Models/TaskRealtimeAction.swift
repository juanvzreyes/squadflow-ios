//
//  TaskRealtimeAction.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import Foundation

enum TaskRealtimeAction {
    case insert(TaskItem)
    case update(TaskItem)
    case delete(UUID)
}
