//
//  StatsManager.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/9/25.
//

class StatsManager {
    
    static let shared = StatsManager()
    
    private init() {}
    
    func fetchCurrentUsername(forUserUID userUID: String) async throws -> String? {
        return try await FirestoreService.shared.fetchCurrentUsername(forUserUID: userUID)
    }
}
