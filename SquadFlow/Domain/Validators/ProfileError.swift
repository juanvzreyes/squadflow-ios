//
//  ProfileError.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 06/08/26.
//

import Foundation

enum ProfileError: LocalizedError {
    case emptyUsername
    case usernameTooShort
    case usernameTaken
    case uploadFailed

    var errorDescription: String? {
        switch self {
        case .emptyUsername: "El nombre de usuario no puede estar vacío"
        case .usernameTooShort: "El nombre de usuario debe tener al menos 3 caracteres"
        case .usernameTaken: "Ese nombre de usuario ya está en uso"
        case .uploadFailed: "No se pudo subir la imagen"
        }
    }
}
