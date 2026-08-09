//
//  TaskRowView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskRowView: View {
    let displayInfo: TaskDisplayInfo
    let onTap: () -> Void
    let onDelete: () -> Void

    private var task: TaskItem { displayInfo.task }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.headline)
            if let description = task.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                StatusBadgeView(
                    text: task.status.displayName,
                    color: task.status.color
                )

                Spacer()

                VStack(alignment: .trailing) {
                    Text("De: \(displayInfo.creatorName)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)

                    HStack(spacing: 4) {
                        AvatarCircleView(avatarUrl: displayInfo.assigneeAvatarUrl, size: 20)
                        Text(displayInfo.assigneeName)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }
}

#Preview {
    List {
        TaskRowView(
            displayInfo: TaskDisplayInfo(
                task: TaskItem(
                    id: UUID(),
                    workspaceId: UUID(),
                    title: "Diseñar pantalla de login",
                    description: "Incluir validación de campos y estado de carga",
                    status: .inProgress,
                    assignedTo: nil,
                    createdBy: nil,
                    createdAt: .now
                ),
                assigneeName: "Sin asignar",
                assigneeAvatarUrl: nil,
                creatorName: "Desconocido",
                creatorAvatarUrl: nil
            )
        ) {
        } onDelete: {
        }
    }
}
