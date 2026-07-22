//
//  AuthValidator.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 22/07/26.
//

import Foundation

enum AuthValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return (try? emailRegex.wholeMatch(in: email)) != nil
    }

    static func isValidPassword(_ password: String) -> Bool {
        password.count >= 6
    }

    static func isValidCredentials(email: String, password: String) -> Bool {
        isValidEmail(email) && isValidPassword(password)
    }
}
