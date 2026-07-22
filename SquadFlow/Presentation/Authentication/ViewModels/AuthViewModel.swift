//
//  AuthViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    var isFormValid: Bool {
        AuthValidator.isValidCredentials(email: email, password: password)
    }

    func signIn() async {
        guard isFormValid else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await repository.signIn(email: email, password: password)
        } catch {
            errorMessage = "El correo o la contraseña son incorrectos."
        }

        isLoading = false
    }

    func signUp() async {
        guard isFormValid else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await repository.signUp(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
