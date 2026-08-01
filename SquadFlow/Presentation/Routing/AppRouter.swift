//
//  AppRouter.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class AppRouter {
    var isAuthenticated = false
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func listenToAuthState() async {
        for await isAuth in repository.authStateStream() {
            withAnimation {
                self.isAuthenticated = isAuth
            }
        }
    }

    func signOut() async {
        try? await repository.signOut()
    }
}
