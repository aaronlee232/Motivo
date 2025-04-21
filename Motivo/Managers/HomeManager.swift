//
//  HomeManager.swift
//  Motivo
//
//  Created by Aaron Lee on 4/20/25.
//

class HomeManager {
    func fetchCurrentUsername(forUserUID userUID: String) async throws -> String {
        let profileManager = ProfileManager()
        return try await profileManager.fetchCurrentUsername(forUserUID: userUID)
    }
    
    func fetchGroupMetadataList(forUserUID userUID: String) async throws -> [GroupMetadata] {
        let groupManager = GroupManager()
        return try await groupManager.fetchGroupMetadataList(forUserUID: userUID)
    }
}
