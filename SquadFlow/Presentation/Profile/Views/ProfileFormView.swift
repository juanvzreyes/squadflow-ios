//
//  ProfileFormView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import SwiftUI

struct ProfileFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: ProfileViewModel

    private var isFormValid: Bool {
        viewModel.editUsername.trimmingCharacters(in: .whitespaces).count >= 3
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        AvatarPickerView(
                            editAvatarImage: $viewModel.editAvatarImage,
                            avatarRemoved: $viewModel.avatarRemoved,
                            currentAvatarUrl: viewModel.profile?.avatarUrl
                        )
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section("Información personal") {
                    TextField(
                        "Nombre de usuario",
                        text: $viewModel.editUsername
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    TextField("Nombre completo", text: $viewModel.editFullName)
                }
            }
            .navigationTitle("Editar perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task { await viewModel.updateProfile() }
                    }
                    .disabled(!isFormValid || viewModel.isSaving)
                }
            }
            .onAppear {
                viewModel.prepareEditForm()
            }
        }
    }
}
