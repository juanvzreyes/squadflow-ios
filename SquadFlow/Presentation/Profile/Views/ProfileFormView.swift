//
//  ProfileFormView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import SwiftUI

struct ProfileFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var formViewModel: ProfileFormViewModel
    let onSave: () async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        AvatarPickerView(
                            editAvatarImage: $formViewModel.avatarImage,
                            avatarRemoved: $formViewModel.avatarRemoved,
                            currentAvatarUrl: formViewModel.currentAvatarUrl
                        )
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section("Información personal") {
                    TextField(
                        "Nombre de usuario",
                        text: $formViewModel.username
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    TextField("Nombre completo", text: $formViewModel.fullName)
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
                        Task { await onSave() }
                    }
                    .disabled(!formViewModel.isFormValid || formViewModel.isSaving)
                }
            }
        }
    }
}
