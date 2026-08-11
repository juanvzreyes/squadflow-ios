//
//  AuthView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import GoogleSignInSwift
import SwiftUI

struct AuthView: View {
    @Environment(\.colorScheme) private var colorScheme
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
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button("Entendido", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image("iconFlowSquad")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("SquadFlow")
                .font(.largeTitle.bold())
            Text("Inicia sesión para continuar")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 20)
    }

    private var formSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                TextField("Correo electrónico", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                SecureField("Contraseña", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { Task { await viewModel.signIn() } }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var footerSection: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Button {
                    Task { await viewModel.signIn() }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Iniciar Sesión")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(!viewModel.isFormValid || viewModel.isLoading)

                Button("Crear nueva cuenta") {
                    Task { await viewModel.signUp() }
                }
                .font(.subheadline.bold())
                .foregroundStyle(.tint)
            }
            .padding(.top, 8)

            HStack {
                VStack { Divider() }
                Text("O")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                VStack { Divider() }
            }
            .padding(.horizontal)

            GoogleSignInButton(
                viewModel: GoogleSignInButtonViewModel(
                    scheme: colorScheme == .dark ? .dark : .light,
                    style: .wide,
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
