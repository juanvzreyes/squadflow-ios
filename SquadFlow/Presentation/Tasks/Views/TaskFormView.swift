//
//  TaskFormView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var formViewModel: TaskFormViewModel
    let taskToEdit: TaskItem?
    let members: [Profile]
    let onSave: (String, String?, TaskStatus, UUID?) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles de la tarea") {
                    TextField("Título de la tarea", text: $formViewModel.title)
                    TextField(
                        "Descripción (opcional)",
                        text: $formViewModel.description,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }
                Section("Estado y asignación") {
                    Picker("Estado", selection: $formViewModel.status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(status.displayName).tag(status)
                        }
                    }
                    
                    Picker("Asignar a", selection: $formViewModel.assignedTo) {
                        Text("Sin asignar").tag(UUID?.none)
                        ForEach(members) { member in
                            Text(member.username ?? member.fullName ?? "Sin nombre").tag(UUID?.some(member.id))
                        }
                    }
                }
            }
            .navigationTitle(taskToEdit == nil ? "Nueva tarea" : "Editar tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            formViewModel.isSaving = true
                            await onSave(
                                formViewModel.title,
                                formViewModel.description.isEmpty ? nil : formViewModel.description,
                                formViewModel.status,
                                formViewModel.assignedTo
                            )
                            formViewModel.isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(!formViewModel.isFormValid || formViewModel.isSaving)
                }
            }
            .onAppear {
                if let task = taskToEdit {
                    formViewModel.loadTask(task)
                }
            }
        }
    }
}

#Preview {
    TaskFormView(
        formViewModel: TaskFormViewModel(),
        taskToEdit: nil,
        members: [
            Profile(
                id: UUID(),
                username: "juanvzreyes",
                fullName: "Juan Reyes",
                avatarUrl: nil,
                updatedAt: nil
            ),
            Profile(
                id: UUID(),
                username: "luismiguel_oficial",
                fullName: "Luis Miguel",
                avatarUrl: nil,
                updatedAt: nil
            )
        ]
    ) { _, _, _, _ in }
}
