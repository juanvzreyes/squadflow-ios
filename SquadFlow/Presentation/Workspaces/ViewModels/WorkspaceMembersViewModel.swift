//
//  WorkspaceMembersViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 03/08/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class WorkspaceMembersViewModel {
    var members: [Profile]
    var searchResults: [Profile] = []
    var inviteErrorMessage: String?
    var isSearching = false
    let currentUserId: UUID?

    private let inviteUseCase: CreateMemberInvitationUseCase
    private let searchProfilesUseCase: SearchProfilesUseCase
    private let removeMemberUseCase: RemoveMemberFromWorkspaceUseCase
    private let workspaceId: UUID
    private let onMemberAdded: ((Profile) -> Void)?
    private var searchTask: Task<Void, Never>?

    init(
        members: [Profile],
        workspaceId: UUID,
        currentUserId: UUID?,
        repository: WorkspaceRepositoryProtocol,
        onMemberAdded: ((Profile) -> Void)? = nil
    ) {
        self.members = members
        self.workspaceId = workspaceId
        self.currentUserId = currentUserId
        self.inviteUseCase = CreateMemberInvitationUseCase(repository: repository)
        self.searchProfilesUseCase = SearchProfilesUseCase(repository: repository)
        self.removeMemberUseCase = RemoveMemberFromWorkspaceUseCase(repository: repository)
        self.onMemberAdded = onMemberAdded
    }

    // MARK: - Searchable with debounce

    func updateSearch(query: String) {
        searchTask?.cancel()
        inviteErrorMessage = nil

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            searchResults = []
            isSearching = false
            return
        }

        isSearching = true
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await performSearch(query: trimmed)
        }
    }

    private func performSearch(query: String) async {
        do {
            let results = try await searchProfilesUseCase.execute(query: query, currentMembers: members)
            guard !Task.isCancelled else { return }
            searchResults = results
        } catch {
            guard !Task.isCancelled else { return }
            searchResults = []
        }
        isSearching = false
    }

    // MARK: - Invitation

    func inviteMember(profile: Profile) async {
        inviteErrorMessage = nil
        do {
            try await inviteUseCase.execute(
                workspaceId: workspaceId,
                profile: profile,
                currentMembers: members
            )
            withAnimation {
                members.append(profile)
                searchResults.removeAll { $0.id == profile.id }
            }
            onMemberAdded?(profile)
        } catch {
            inviteErrorMessage = error.localizedDescription
        }
    }

    // MARK: - Remove

    func removeMember(profile: Profile) async {
        let backupMembers = members

        withAnimation {
            members.removeAll { $0.id == profile.id }
        }

        do {
            try await removeMemberUseCase.execute(
                workspaceId: workspaceId,
                profileId: profile.id
            )
        } catch {
            withAnimation {
                members = backupMembers
            }
            inviteErrorMessage = "No tienes permisos para eliminar a este miembro del equipo"
        }
    }
}
