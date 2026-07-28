//
//  EmptyStateView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "Sin registros",
            systemImage: "tray.fill",
            description: Text("No hay registros en este espacio de trabajo")
        )
    }
}

#Preview {
    EmptyStateView()
}
