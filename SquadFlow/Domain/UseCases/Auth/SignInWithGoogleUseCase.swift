//
//  SignInWithGoogleUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 09/08/26.
//

import Foundation

struct SignInWithGoogleUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.signInWithGoogle()
    }
}
