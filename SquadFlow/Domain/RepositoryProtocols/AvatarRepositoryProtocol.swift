//
//  AvatarRepositoryProtocol.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation

protocol AvatarRepositoryProtocol: Sendable {
    func uploadAvatar(imageData: Data, previousAvatarUrl: String?) async throws -> String
    func deleteAvatar(avatarUrl: String) async throws
}
