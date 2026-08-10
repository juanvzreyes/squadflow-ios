//
//  AuthView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import GoogleSignInSwift
import SwiftUI

struct AuthView: View {
    @Bindable var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                headerSection
                formSection
                footerSection
                Spacer()
            }
            .padding()
            .disabled(viewModel.isLoading)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("SquadFlow")
                .font(.largeTitle.bold())
            Text("Inicia sesión para continuar")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 32)
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Correo electrónico", text: $viewModel.email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }

            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit { Task { await viewModel.signIn() } }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, 4)
            }
        }
    }

    private var footerSection: some View {
        VStack(spacing: 16) {
            Button {
                Task { await viewModel.signIn() }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Iniciar Sesión")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)

            Button("Crear nueva cuenta") {
                Task { await viewModel.signUp() }
            }
            .font(.subheadline)
            .buttonStyle(.plain)

            GoogleSignInButton(
                viewModel: GoogleSignInButtonViewModel(
                    scheme: .light,
                    style: .standard,
                    state: viewModel.isLoading ? .disabled : .normal
                )
            ) {
                Task { await viewModel.signInWithGoogle() }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .disabled(viewModel.isLoading)
        }
    }
}

#Preview {
    let viewModel = AuthViewModel(repository: MockAuthRepository())
    AuthView(viewModel: viewModel)
}
