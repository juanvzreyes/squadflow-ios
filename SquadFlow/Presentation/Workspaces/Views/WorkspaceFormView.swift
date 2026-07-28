//
//  WorkspaceFormView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 28/07/26.
//

import SwiftUI

struct WorkspaceFormView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (String) async -> Void

    @State private var name: String = ""
    @State private var isSaving = false

    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles del espacio") {
                    TextField("Nombre del espacio o equipo", text: $name)
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
                            isSaving = true
                            await onSave(name)
                            isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(!isFormValid || isSaving)
                }
            }
        }
    }
}
