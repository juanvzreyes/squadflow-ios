//
//  TaskListContent.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskListContent: View {
    let displayItems: [TaskDisplayInfo]
    let onTap: (TaskItem) -> Void
    let onDelete: (TaskItem) -> Void

    var body: some View {
        List {
            ForEach(displayItems, id: \.task.id) { item in
                TaskRowView(
                    displayInfo: item,
                    onTap: { onTap(item.task) },
                    onDelete: { onDelete(item.task) }
                )
            }
        }
    }
}
