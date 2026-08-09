//
//  ProfileViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel {
    var profile: Profile?
    var isLoading = false
    var errorMessage: String?
    var isShowingEditForm = false

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

    func updateProfile(using formViewModel: ProfileFormViewModel) async {
        formViewModel.isSaving = true
        errorMessage = nil

        do {
            profile = try await updateProfileUseCase.execute(
                username: formViewModel.username,
                fullName: formViewModel.fullName,
                avatarAction: formViewModel.buildAvatarAction(),
                currentAvatarUrl: profile?.avatarUrl
            )
            isShowingEditForm = false
        } catch {
            errorMessage = error.localizedDescription
        }

        formViewModel.isSaving = false
    }
}
