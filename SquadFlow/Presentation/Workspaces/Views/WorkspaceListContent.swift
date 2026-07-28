//
//  WorkspaceListContent.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct WorkspaceListContent: View {
    let workspaces: [Workspace]
    let onDelete: (Workspace) -> Void

    var body: some View {
        List {
            ForEach(workspaces) { workspace in
                NavigationLink(value: workspace) {
                    WorkspaceRowView(workspace: workspace)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        onDelete(workspace)
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                    }
                }
            }
        }
    }
}
