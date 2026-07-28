//
//  EmptyWorkspaceView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct EmptyWorkspaceView: View {
    var body: some View {
        ContentUnavailableView(
            "Sin equipos",
            systemImage: "briefcase.fill",
            description: Text("Crea un espacio de trabajo para comenzar")
        )
    }
}

#Preview {
    EmptyWorkspaceView()
}
