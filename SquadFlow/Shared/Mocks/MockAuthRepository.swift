//
//  MockAuthRepository.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 30/07/26.
//

import Foundation

final class MockAuthRepository: AuthRepositoryProtocol {
    func signUp(email: String, password: String) async throws {}
    func signIn(email: String, password: String) async throws {}
    func signInWithGoogle() async throws {}
    func signOut() async throws {}

    func authStateStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            continuation.yield(false)
        }
    }
    
    func currentUserId() async -> UUID? {
        return UUID()
    }
}
