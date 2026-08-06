//
//  UpdateProfileUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation
import Supabase

enum AvatarAction {
    case keep
    case update(Data)
    case remove
}

struct UpdateProfileUseCase {
    private let profileRepository: ProfileRepositoryProtocol
    private let avatarRepository: AvatarRepositoryProtocol

    init(
        profileRepository: ProfileRepositoryProtocol,
        avatarRepository: AvatarRepositoryProtocol
    ) {
        self.profileRepository = profileRepository
        self.avatarRepository = avatarRepository
    }

    func execute(username: String, fullName: String, avatarAction: AvatarAction, currentAvatarUrl: String?) async throws -> Profile {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFullName = fullName.trimmingCharacters(in: .whitespaces)

        guard !trimmedUsername.isEmpty else {
            throw ProfileError.emptyUsername
        }

        guard trimmedUsername.count >= 3 else {
            throw ProfileError.usernameTooShort
        }

        let finalAvatarUrl = try await processAvatar(
            action: avatarAction,
            currentUrl: currentAvatarUrl
        )

        return try await saveProfileData(
            username: trimmedUsername,
            fullName: trimmedFullName,
            avatarUrl: finalAvatarUrl
        )
    }

    private func processAvatar(action: AvatarAction, currentUrl: String?) async throws -> String? {
        switch action {
        case .keep:
            return currentUrl

        case .update(let imageData):
            do {
                return try await avatarRepository.uploadAvatar(imageData: imageData, previousAvatarUrl: currentUrl)
            } catch {
                throw ProfileError.uploadFailed
            }

        case .remove:
            if let currentUrl = currentUrl {
                try? await avatarRepository.deleteAvatar(avatarUrl: currentUrl)
            }
            return nil
        }
    }

    private func saveProfileData(username: String, fullName: String, avatarUrl: String?) async throws -> Profile {
        do {
            return try await profileRepository.updateProfile(
                username: username,
                fullName: fullName,
                avatarUrl: avatarUrl
            )
        } catch let error as PostgrestError where error.code == "23505" {
            throw ProfileError.usernameTaken
        }
    }
}
