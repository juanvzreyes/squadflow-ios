//
//  AuthRepositoryProtocol.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation

protocol AuthRepositoryProtocol: Sendable {
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signInWithGoogle() async throws
    func signOut() async throws
    func authStateStream() -> AsyncStream<Bool>
    func currentUserId() async -> UUID?
}
