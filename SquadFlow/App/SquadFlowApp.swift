//
//  SquadFlowApp.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 13/07/26.
//

import SwiftUI
import GoogleSignIn

@main
struct SquadFlowApp: App {
    @State private var container: DependencyContainer
    @State private var router: AppRouter

    init() {
        let container = DependencyContainer()
        let router = AppRouter(repository: container.authRepository)
        _container = State(initialValue: container)
        _router = State(initialValue: router)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .environment(container)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
