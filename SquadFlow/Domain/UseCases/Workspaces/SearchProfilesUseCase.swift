//
//  SearchProfilesUseCase.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import Foundation

struct SearchProfilesUseCase {
    private let repository: WorkspaceRepositoryProtocol

    init(repository: WorkspaceRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String, currentMembers: [Profile] = []) async throws -> [Profile] {
        let results = try await repository.searchProfiles(query: query)

        if !currentMembers.isEmpty {
            let memberIds = Set(currentMembers.map(\.id))
            return results.filter { !memberIds.contains($0.id) }
        }

        return results
    }
}
