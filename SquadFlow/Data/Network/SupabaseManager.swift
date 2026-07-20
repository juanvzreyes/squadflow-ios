//
//  SupabaseManager.swift
//  SquadFlow
//
//  Created by Juan Adolfo Velazquez Reyes on 20/07/26.
//

import Foundation
import Supabase

enum SupabaseConfig {
    static let url = URL(string: "https://opzmpqvzmcngphfknpxt.supabase.co")!
    static let key = "sb_publishable_yx2t6BOap-XNEfnnlck7OA_TbCUV6iq"
}

final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: SupabaseConfig.url,
            supabaseKey: SupabaseConfig.key
        )
    }
}
