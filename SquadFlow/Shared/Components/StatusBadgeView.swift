//
//  StatusBadgeView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import SwiftUI

struct StatusBadgeView: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text.uppercased())
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        StatusBadgeView(text: "Por hacer", color: .gray)
        StatusBadgeView(text: "En progreso", color: .blue)
        StatusBadgeView(text: "En revisión", color: .orange)
        StatusBadgeView(text: "Completado", color: .green)
    }
    .padding()
}
