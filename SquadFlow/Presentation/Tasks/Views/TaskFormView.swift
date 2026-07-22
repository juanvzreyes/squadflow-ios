//
//  TaskFormView.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    let taskToEdit: TaskItem?
    let onSave: (String, String?, TaskStatus) async -> Void

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var status: TaskStatus = .todo
    @State private var isSaving = false

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles de la tarea") {
                    TextField("Título de la tarea", text: $title)
                    TextField(
                        "Descripción (opcional)",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }
                Section("Estado") {
                    Picker("Estado", selection: $status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(status.displayName).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
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
                            isSaving = true
                            await onSave(
                                title,
                                description.isEmpty ? nil : description,
                                status
                            )
                            isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(!isFormValid || isSaving)
                }
            }
            .onAppear {
                if let task = taskToEdit {
                    title = task.title
                    description = task.description ?? ""
                    status = task.status
                }
            }
        }
    }
}

#Preview {
    TaskFormView(taskToEdit: nil) { _, _, _ in }
}
