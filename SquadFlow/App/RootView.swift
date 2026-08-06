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
    @State private var profileViewModel: ProfileViewModel?

    var body: some View {
        Group {
            if router.isAuthenticated {
                if let workspaceViewModel, let profileViewModel {
                    TabView {
                        Tab("Espacios", systemImage: "briefcase") {
                            WorkspaceListView(viewModel: workspaceViewModel)
                        }

                        Tab("Perfil", systemImage: "person.crop.circle") {
                            ProfileView(viewModel: profileViewModel)
                        }
                    }
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
                workspaceViewModel = WorkspaceListViewModel(repository: container.workspaceRepository)
            }
            if profileViewModel == nil {
                profileViewModel = ProfileViewModel(
                    profileRepository: container.profileRepository,
                    avatarRepository: container.avatarRepository
                )
            }
        }
        .task {
            await router.listenToAuthState()
        }
    }
}
