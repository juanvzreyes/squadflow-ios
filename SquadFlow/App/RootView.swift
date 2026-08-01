//
//  RootView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DependencyContainer.self) private var container
    @State private var authViewModel: AuthViewModel?
    @State private var workspaceViewModel: WorkspaceListViewModel?

    var body: some View {
        Group {
            if router.isAuthenticated {
                if let workspaceViewModel {
                    WorkspaceListView(viewModel: workspaceViewModel)
                }
            } else {
                if let authViewModel {
                    AuthView(viewModel: authViewModel)
                }
            }
        }
        .onAppear {
            if authViewModel == nil {
                authViewModel = AuthViewModel(repository: container.authRepository)
            }
            if workspaceViewModel == nil {
                workspaceViewModel = WorkspaceListViewModel(
                    repository: container.workspaceRepository
                )
            }
        }
        .task {
            await router.listenToAuthState()
        }
    }
}
