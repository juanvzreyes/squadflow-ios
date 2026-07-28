//
//  WorkspaceRowView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct WorkspaceRowView: View {
    let workspace: Workspace

    var body: some View {
        Text(workspace.name)
            .font(.headline)
            .padding(.vertical, 4)
    }
}
