//
//  KanbanColumnView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 11/08/26.
//

import SwiftUI

struct KanbanColumnView: View {
    let status: TaskStatus
    let items: [TaskDisplayInfo]
    let onTap: (TaskItem) -> Void
    let onStatusChange: (UUID, TaskStatus) -> Void

    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .fill(status.color)
                    .frame(width: 10, height: 10)

                Text(status.displayName)
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Text("\(items.count)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.quaternary, in: Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Divider()

            ScrollView(.vertical) {
                LazyVStack(spacing: 8) {
                    ForEach(items, id: \.task.id) { item in
                        KanbanCardView(
                            displayInfo: item,
                            onTap: { onTap(item.task) }
                        )
                    }
                }
                .padding(8)
            }
        }
        .frame(width: 280)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isTargeted
                        ? status.color.opacity(0.08)
                        : Color(.systemGroupedBackground)
                )
                .animation(.easeInOut(duration: 0.2), value: isTargeted)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isTargeted ? status.color.opacity(0.4) : .clear,
                    lineWidth: 2
                )
                .animation(.easeInOut(duration: 0.2), value: isTargeted)
        )
        .dropDestination(for: String.self) { droppedItems, _ in
            guard let taskIdString = droppedItems.first,
                let taskId = UUID(uuidString: taskIdString)
            else { return false }
            onStatusChange(taskId, status)
            return true
        } isTargeted: { targeted in
            isTargeted = targeted
        }
    }
}

#Preview {
    KanbanColumnView(
        status: .inProgress,
        items: [
            TaskDisplayInfo(
                task: TaskItem(
                    id: UUID(),
                    workspaceId: UUID(),
                    title: "Ejemplo de tarea en progreso",
                    description: "Esta es una descripción de ejemplo",
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
        onTap: { _ in },
        onStatusChange: { _, _ in }
    )
    .padding()
}
