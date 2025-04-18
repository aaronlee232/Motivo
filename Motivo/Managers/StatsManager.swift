//
//  StatsManager.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/9/25.
//

class StatsManager {
    
    func fetchCurrentUsername(forUserUID userUID: String) async throws -> String? {
        let user = try await FirestoreService.shared.fetchUser(forUserUID: userUID)
        return user?.username ?? "Unknown Username"
    }
    
    func fetchCurrentNumberOfHabits(forUserUID userUID: String) async throws -> Int {
        let numberOfHabits = try await FirestoreService.shared.fetchHabits(forUserUID: userUID)
        return numberOfHabits.count
    }
}
