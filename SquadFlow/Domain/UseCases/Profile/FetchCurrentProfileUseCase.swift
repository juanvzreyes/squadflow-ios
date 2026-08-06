//
//  FetchCurrentProfileUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation

struct FetchCurrentProfileUseCase {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> Profile {
        try await repository.getCurrentProfile()
    }
}
