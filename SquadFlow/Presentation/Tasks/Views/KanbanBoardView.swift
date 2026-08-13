//
//  KanbanBoardView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 11/08/26.
//

import SwiftUI

struct KanbanBoardView: View {
    let tasksByStatus: [TaskStatus: [TaskDisplayInfo]]
    let onTap: (TaskItem) -> Void
    let onStatusChange: (UUID, TaskStatus) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(TaskStatus.allCases, id: \.self) { status in
                    KanbanColumnView(
                        status: status,
                        items: tasksByStatus[status] ?? [],
                        onTap: onTap,
                        onStatusChange: onStatusChange
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    KanbanBoardView(
        tasksByStatus: [
            .todo: [
                TaskDisplayInfo(
                    task: TaskItem(
                        id: UUID(),
                        workspaceId: UUID(),
                        title: "Diseñar pantalla de login",
                        description: "Incluir validación de campos",
                        status: .todo,
                        assignedTo: nil,
                        createdBy: nil,
                        createdAt: .now
                    ),
                    assigneeName: "Sin asignar",
                    assigneeAvatarUrl: nil,
                    creatorName: "Juan Reyes",
                    creatorAvatarUrl: nil
                )
            ],
            .inProgress: [
                TaskDisplayInfo(
                    task: TaskItem(
                        id: UUID(),
                        workspaceId: UUID(),
                        title: "Implementar autenticación",
                        description: nil,
                        status: .inProgress,
                        assignedTo: nil,
                        createdBy: nil,
                        createdAt: .now
                    ),
                    assigneeName: "Juan Reyes",
                    assigneeAvatarUrl: nil,
                    creatorName: "Juan Reyes",
                    creatorAvatarUrl: nil
                )
            ],
        ],
        onTap: { _ in },
        onStatusChange: { _, _ in }
    )
}
