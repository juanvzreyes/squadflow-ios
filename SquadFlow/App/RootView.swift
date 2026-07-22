//
//  RootView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

private let defaultWorkspaceId = UUID(uuidString: "11111111-2222-3333-4444-555555555555")!

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @State private var authViewModel: AuthViewModel
    @State private var taskViewModel: TaskListViewModel
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
        _authViewModel = State(initialValue: AuthViewModel(repository: repository))
        _taskViewModel = State(
            initialValue: TaskListViewModel(
                repository: TaskRepository(),
                workspaceId: defaultWorkspaceId
            )
        )
    }

    var body: some View {
        Group {
            if router.isAuthenticated {
                TaskListView(viewModel: taskViewModel, authRepository: repository)
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
        .task {
            await router.listenToAuthState()
        }
    }
}
