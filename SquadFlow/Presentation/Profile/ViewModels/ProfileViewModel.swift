//
//  ProfileViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class ProfileViewModel {
    var profile: Profile?
    var isLoading = false
    var errorMessage: String?
    var isShowingEditForm = false

    var editUsername: String = ""
    var editFullName: String = ""
    var isSaving = false

    var editAvatarImage: AvatarImage?
    var avatarRemoved = false

    private let fetchCurrentProfileUseCase: FetchCurrentProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase

    init(profileRepository: ProfileRepositoryProtocol, avatarRepository: AvatarRepositoryProtocol) {
        self.fetchCurrentProfileUseCase = FetchCurrentProfileUseCase(repository: profileRepository)
        self.updateProfileUseCase = UpdateProfileUseCase(
            profileRepository: profileRepository,
            avatarRepository: avatarRepository
        )
    }

    func fetchProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            profile = try await fetchCurrentProfileUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func prepareEditForm() {
        editUsername = profile?.username ?? ""
        editFullName = profile?.fullName ?? ""
        editAvatarImage = nil
        avatarRemoved = false
    }

    func updateProfile() async {
        isSaving = true
        errorMessage = nil

        let avatarAction: AvatarAction
        if avatarRemoved {
            avatarAction = .remove
        } else if let data = editAvatarImage?.data {
            avatarAction = .update(data)
        } else {
            avatarAction = .keep
        }

        do {
            profile = try await updateProfileUseCase.execute(
                username: editUsername,
                fullName: editFullName,
                avatarAction: avatarAction,
                currentAvatarUrl: profile?.avatarUrl
            )
            isShowingEditForm = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isSaving = false
    }
}
