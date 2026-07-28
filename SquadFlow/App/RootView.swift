//
//  RootView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @State private var authViewModel: AuthViewModel
    @State private var workspaceViewModel: WorkspaceListViewModel
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
        _authViewModel = State(initialValue: AuthViewModel(repository: repository))
        _workspaceViewModel = State(
            initialValue: WorkspaceListViewModel(
                repository: WorkspaceRepository()
            )
        )
    }

    var body: some View {
        Group {
            if router.isAuthenticated {
                WorkspaceListView(
                    viewModel: workspaceViewModel,
                    authRepository: repository
                )
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
        .task {
            await router.listenToAuthState()
        }
    }
}
