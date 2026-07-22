//
//  TaskRowView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let onTap: () -> Void
    let onDelete: () -> Void

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

            Text(task.status.displayName.uppercased())
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(task.status.color.opacity(0.15))
                .foregroundStyle(task.status.color)
                .clipShape(Capsule())
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
            onTap: {},
            onDelete: {}
        )
    }
}
