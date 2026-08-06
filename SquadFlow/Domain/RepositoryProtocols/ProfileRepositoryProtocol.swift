//
//  ProfileRepositoryProtocol.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation

protocol ProfileRepositoryProtocol: Sendable {
    func getCurrentProfile() async throws -> Profile
    func updateProfile(username: String, fullName: String, avatarUrl: String?) async throws -> Profile
}
