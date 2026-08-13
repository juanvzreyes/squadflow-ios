//
//  KanbanCardView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 11/08/26.
//

import SwiftUI

struct KanbanCardView: View {
    let displayInfo: TaskDisplayInfo
    let onTap: () -> Void

    private var task: TaskItem { displayInfo.task }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)

            if let description = task.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            HStack(spacing: 6) {
                AvatarCircleView(
                    avatarUrl: displayInfo.assigneeAvatarUrl,
                    size: 20
                )
                Text(displayInfo.assigneeName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Spacer()

                Text("De: \(displayInfo.creatorName)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture(perform: onTap)
        .draggable(task)
    }
}

#Preview {
    KanbanCardView(
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
            creatorName: "Juan Reyes",
            creatorAvatarUrl: nil
        )
    ) {}
    .padding()
}
