//
//  TaskListContent.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskListContent: View {
    let tasks: [TaskItem]
    let onTap: (TaskItem) -> Void
    let onDelete: (TaskItem) -> Void

    var body: some View {
        List {
            ForEach(tasks) { task in
                TaskRowView(
                    task: task,
                    onTap: { onTap(task) },
                    onDelete: { onDelete(task) }
                )
            }
        }
    }
}
