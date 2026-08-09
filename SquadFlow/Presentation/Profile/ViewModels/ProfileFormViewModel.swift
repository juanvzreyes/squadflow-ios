//
//  ProfileFormViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 07/08/26.
//

import Foundation

@MainActor
@Observable
final class ProfileFormViewModel {
    var username: String = ""
    var fullName: String = ""
    var currentAvatarUrl: String?
    var avatarImage: AvatarImage?
    var avatarRemoved: Bool = false
    var isSaving: Bool = false

    var isFormValid: Bool {
        username.trimmingCharacters(in: .whitespaces).count >= 3
    }

    func prepare(with profile: Profile?) {
        username = profile?.username ?? ""
        fullName = profile?.fullName ?? ""
        currentAvatarUrl = profile?.avatarUrl
        avatarImage = nil
        avatarRemoved = false
        isSaving = false
    }

    func buildAvatarAction() -> AvatarAction {
        if avatarRemoved {
            return .remove
        } else if let data = avatarImage?.data {
            return .update(data)
        } else {
            return .keep
        }
    }
}
