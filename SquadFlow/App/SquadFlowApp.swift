//
//  SquadFlowApp.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 13/07/26.
//

import SwiftUI

@main
struct SquadFlowApp: App {
    @State private var repository = AuthRepository()
    @State private var router: AppRouter

    init() {
        let repo = AuthRepository()
        _repository = State(initialValue: repo)
        _router = State(initialValue: AppRouter(repository: repo))
    }

    var body: some Scene {
        WindowGroup {
            RootView(repository: repository)
                .environment(router)
        }
    }
}

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @State private var authViewModel: AuthViewModel
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
        _authViewModel = State(initialValue: AuthViewModel(repository: repository))
    }

    var body: some View {
        Group {
            if router.isAuthenticated {
                VStack(spacing: 20) {
                    Text("Autenticado")
                    Button("Cerrar sesión") {
                        Task { try? await repository.signOut() }
                    }
                }
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
        .task {
            await router.listenToAuthState()
        }
    }
}
