//
//  ErrorStateView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack {
            Text("Error al cargar")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.red)
            Button("Reintentar", action: onRetry)
                .padding(.top)
        }
    }
}

#Preview {
    ErrorStateView(message: "No se pudo conectar al servidor") {}
}
