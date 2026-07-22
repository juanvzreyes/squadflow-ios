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
