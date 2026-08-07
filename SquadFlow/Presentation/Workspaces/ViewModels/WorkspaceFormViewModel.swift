//
//  WorkspaceFormViewModel.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 07/08/26.
//

import Foundation

@MainActor
@Observable
final class WorkspaceFormViewModel {
    var name: String = ""
    var isSaving: Bool = false

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func reset() {
        name = ""
        isSaving = false
    }
}
