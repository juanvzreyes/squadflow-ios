//
//  AvatarRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation
import Supabase

final class AvatarRepository: AvatarRepositoryProtocol {
    private let client = SupabaseManager.shared.client

    func uploadAvatar(imageData: Data, previousAvatarUrl: String?) async throws -> String {
        if let previousUrl = previousAvatarUrl {
            try? await deleteAvatar(avatarUrl: previousUrl)
        }
        let filePath = "\(UUID().uuidString).jpeg"

        try await client.storage
            .from("avatars")
            .upload(
                filePath,
                data: imageData,
                options: FileOptions(contentType: "image/jpeg", upsert: true)
            )

        let publicURL = try client.storage
            .from("avatars")
            .getPublicURL(path: filePath)

        return publicURL.absoluteString
    }

    func deleteAvatar(avatarUrl: String) async throws {
        guard let filePath = extractFilePath(from: avatarUrl) else { return }
        try await client.storage
            .from("avatars")
            .remove(paths: [filePath])
    }

    private func extractFilePath(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        let pathComponents = url.pathComponents
        guard let avatarsIndex = pathComponents.firstIndex(of: "avatars"), avatarsIndex + 1 < pathComponents.count
        else { return nil }
        return pathComponents[(avatarsIndex + 1)...].joined(separator: "/")
    }
}
