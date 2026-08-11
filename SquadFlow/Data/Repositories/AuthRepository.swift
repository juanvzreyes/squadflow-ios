//
//  AuthRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation
import Supabase
import GoogleSignIn
import UIKit

final class AuthRepository: AuthRepositoryProtocol {
    private let client = SupabaseManager.shared.client

    func signUp(email: String, password: String) async throws {
        _ = try await client.auth.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        _ = try await client.auth.signIn(email: email, password: password)
    }

    func signInWithGoogle() async throws {
        guard let rootViewController = rootViewController() else {
            throw AuthError.missingRootViewController
        }

        let config = GIDConfiguration(
            clientID: Secrets.googleClientID,
            serverClientID: Secrets.googleServerClientID
        )
        GIDSignIn.sharedInstance.configuration = config

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.missingGoogleToken
        }

        try await client.auth.signInWithIdToken(
            credentials: OpenIDConnectCredentials(
                provider: .google,
                idToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
        )
    }

    func signOut() async throws {
        try await client.auth.signOut()
        GIDSignIn.sharedInstance.signOut()
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

    // MARK: - Private helpers

    @MainActor
    private func rootViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
