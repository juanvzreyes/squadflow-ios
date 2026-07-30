//
//  TaskFormViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 29/07/26.
//

import Foundation

@MainActor
@Observable
final class TaskFormViewModel {
    var title: String = ""
    var description: String = ""
    var status: TaskStatus = .todo
    var assignedTo: UUID? = nil
    var isSaving = false

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func loadTask(_ task: TaskItem) {
        title = task.title
        description = task.description ?? ""
        status = task.status
        assignedTo = task.assignedTo
    }

    func reset() {
        title = ""
        description = ""
        status = .todo
        assignedTo = nil
        isSaving = false
    }
}
