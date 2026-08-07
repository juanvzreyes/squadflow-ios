//
//  WorkspaceFormView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct WorkspaceFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var formViewModel: WorkspaceFormViewModel
    let onSave: (String) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles del espacio") {
                    TextField("Nombre del espacio o equipo", text: $formViewModel.name)
                }
            }
            .navigationTitle("Nuevo espacio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        Task {
                            formViewModel.isSaving = true
                            await onSave(formViewModel.name)
                            formViewModel.isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(!formViewModel.isFormValid || formViewModel.isSaving)
                }
            }
        }
    }
}
