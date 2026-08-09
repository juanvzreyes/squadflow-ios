//
//  AuthRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation
import Supabase

final class AuthRepository: AuthRepositoryProtocol {
    private let client = SupabaseManager.shared.client

    func signUp(email: String, password: String) async throws {
        _ = try await client.auth.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        _ = try await client.auth.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    func authStateStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let task = Task {
                for await state in client.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut, .tokenRefreshed].contains(state.event) {
                        let isValid = state.session != nil && !(state.session?.isExpired ?? true)
                        continuation.yield(isValid)
                    }
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    func currentUserId() async -> UUID? {
        try? await client.auth.session.user.id
    }
}
