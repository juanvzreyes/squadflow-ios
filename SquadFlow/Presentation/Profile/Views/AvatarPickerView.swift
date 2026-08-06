//
//  AvatarPickerView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import PhotosUI
import SwiftUI

struct AvatarPickerView: View {
    @Binding var editAvatarImage: AvatarImage?
    @Binding var avatarRemoved: Bool
    let currentAvatarUrl: String?

    @State private var selectedItem: PhotosPickerItem?

    private var hasAvatar: Bool {
        editAvatarImage != nil || (!avatarRemoved && currentAvatarUrl != nil)
    }

    var body: some View {
        let avatarUrl = avatarRemoved ? nil : currentAvatarUrl
        let selectedImage = editAvatarImage?.image

        VStack(spacing: 16) {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                AvatarCircleView(
                    avatarUrl: avatarUrl,
                    selectedImage: selectedImage,
                    size: 150
                )
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "camera.fill")
                        .font(.body)
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                        .offset(x: 4, y: 4)
                }
            }
            .buttonStyle(.plain)
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    guard let newItem,
                        let loaded = try? await newItem.loadTransferable(
                            type: AvatarImage.self
                        )
                    else { return }

                    editAvatarImage = loaded
                    avatarRemoved = false
                }
            }

            if hasAvatar {
                Button(role: .destructive) {
                    editAvatarImage = nil
                    avatarRemoved = true
                    selectedItem = nil
                } label: {
                    Label("Eliminar", systemImage: "trash")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
    }
}
