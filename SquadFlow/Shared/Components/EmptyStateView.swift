//
//  EmptyStateView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct EmptyStateView: View {
    var title: String = "Sin registros"
    var systemImage: String = "tray.fill"
    var description: String = "No hay registros en este espacio de trabajo"

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: systemImage,
            description: Text(description)
        )
    }
}

#Preview {
    EmptyStateView()
}
