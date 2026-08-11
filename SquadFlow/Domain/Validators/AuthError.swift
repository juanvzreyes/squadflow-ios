//
//  AuthError.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 09/08/26.
//

import Foundation

enum AuthError: LocalizedError {
    case missingRootViewController
    case missingGoogleToken

    var errorDescription: String? {
        switch self {
        case .missingRootViewController:
            return "No se pudo obtener la ventana principal de la app"
        case .missingGoogleToken:
            return "No se recibió el token de Google"
        }
    }
}
