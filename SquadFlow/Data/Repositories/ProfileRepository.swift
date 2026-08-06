//
//  ProfileRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation
import Supabase

final class ProfileRepository: ProfileRepositoryProtocol {
    private let client = SupabaseManager.shared.client

    func getCurrentProfile() async throws -> Profile {
        let session = try await client.auth.session
        let userId = session.user.id

        let profile: Profile = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value

        return profile
    }

    func updateProfile(username: String, fullName: String, avatarUrl: String?) async throws -> Profile {
        let session = try await client.auth.session
        let userId = session.user.id

        let payload = ProfileDTOs.UpdatePayload(
            username: username,
            full_name: fullName,
            avatar_url: avatarUrl,
            updated_at: Date()
        )

        let profile: Profile = try await client
            .from("profiles")
            .update(payload)
            .eq("id", value: userId)
            .select()
            .single()
            .execute()
            .value

        return profile
    }
}
