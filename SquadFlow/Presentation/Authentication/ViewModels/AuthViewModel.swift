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

    private let signInUseCase: SignInUseCase
    private let signUpUseCase: SignUpUseCase

    init(repository: AuthRepositoryProtocol) {
        self.signInUseCase = SignInUseCase(repository: repository)
        self.signUpUseCase = SignUpUseCase(repository: repository)
    }

    var isFormValid: Bool {
        AuthValidator.isValidCredentials(email: email, password: password)
    }

    func signIn() async {
        guard isFormValid else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await signInUseCase.execute(email: email, password: password)
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
            try await signUpUseCase.execute(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
