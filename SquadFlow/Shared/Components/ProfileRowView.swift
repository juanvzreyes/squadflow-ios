//
//  ProfileRowView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import SwiftUI

struct ProfileRowView<TrailingContent: View>: View {
    let profile: Profile
    let iconName: String
    let iconColor: Color
    @ViewBuilder let trailingContent: TrailingContent

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(iconColor)

            VStack(alignment: .leading) {
                Text(profile.username ?? "Sin usuario")
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let fullName = profile.fullName {
                    Text(fullName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            trailingContent
        }
    }
}

#Preview {
    ProfileRowView(
        profile: Profile(
            id: UUID(),
            username: "juanvzreyes",
            fullName: "Juan Adolfo Velazquez Reyes",
            avatarUrl: nil,
            updatedAt: nil
        ),
        iconName: "person.crop.circle.fill",
        iconColor: .secondary
    ) {
        EmptyView()
    }
}
