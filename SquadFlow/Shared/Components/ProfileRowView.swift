//
//  ProfileRowView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import SwiftUI

struct ProfileRowView<TrailingContent: View>: View {
    let profile: Profile
    @ViewBuilder let trailingContent: TrailingContent

    var body: some View {
        HStack {
            AvatarCircleView(avatarUrl: profile.avatarUrl, size: 38)

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
        )
    ) {
        EmptyView()
    }
}
