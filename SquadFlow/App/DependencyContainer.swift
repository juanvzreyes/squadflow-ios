//
//  DependencyContainer.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 30/07/26.
//

import Foundation

@MainActor
@Observable
final class DependencyContainer {
    let authRepository: AuthRepositoryProtocol
    let workspaceRepository: WorkspaceRepositoryProtocol
    let taskRepository: TaskRepositoryProtocol
    let profileRepository: ProfileRepositoryProtocol
    let avatarRepository: AvatarRepositoryProtocol

    init(
        authRepository: AuthRepositoryProtocol = AuthRepository(),
        workspaceRepository: WorkspaceRepositoryProtocol = WorkspaceRepository(),
        taskRepository: TaskRepositoryProtocol = TaskRepository(),
        profileRepository: ProfileRepositoryProtocol = ProfileRepository(),
        avatarRepository: AvatarRepositoryProtocol = AvatarRepository()
    ) {
        self.authRepository = authRepository
        self.workspaceRepository = workspaceRepository
        self.taskRepository = taskRepository
        self.profileRepository = profileRepository
        self.avatarRepository = avatarRepository
    }
}
