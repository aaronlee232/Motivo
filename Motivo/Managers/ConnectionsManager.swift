//
//  ConnectionsManager.swift
//  Motivo
//
//  Created by Aaron Lee on 3/11/25.
//

// TODO: one screen for hiding / showing contacts, having local data and updating in firebase
import FirebaseFirestore

class ConnectionsManager {
    
    let db = Firestore.firestore()
    
    // Uses a User's UID to fetch their UserModel in FireStore
    func fetchUser(uid: String) async throws -> UserModel? {
        return try await FirestoreService.shared.fetchUser(forUserUID: uid)
    }
    
    // Uses a User's UID to fetch other related UserModels that are in shared group(s) with the user in FireStore.
    func fetchConnections(for uid: String) async throws -> [UserModel] {
        // Get group IDs where the user is a member
        let groupIDs = try await fetchUserGroupIDs(userUID: uid)
        guard !groupIDs.isEmpty else { return [] } // No groups found

        // Get user UIDs from those groups
        let userUIDs = try await fetchUsersFromGroups(groupIDs: groupIDs, excluding: uid)
        guard !userUIDs.isEmpty else { return [] } // No connected users

        // Fetch user details
        let users = try await FirestoreService.shared.fetchUsers(forUserUIDs: Array(userUIDs))
        return users
    }
    
    // Get the ID's of the groups the given user is a member of.
    private func fetchUserGroupIDs(userUID: String) async throws -> [String] {
        let memberships = try await FirestoreService.shared.fetchGroupMemberships(forUserUID: userUID)
        return memberships.map { membership in membership.groupID }
    }
    
    // Uses groupIDs to retrieve a list of users that are in each of the corresponding groups of those groupIDs in FireStore.
    private func fetchUsersFromGroups(groupIDs: [String], excluding currentUID: String) async throws -> Set<String> {
        guard !groupIDs.isEmpty else { return [] } // Prevents Firestore from failing on empty queries

        let memberships = try await FirestoreService.shared.fetchGroupMemberships(forGroupIDs: groupIDs)

        var userUIDs = Set<String>()
        for membership in memberships {
            if membership.userUID != currentUID {
                userUIDs.insert(membership.userUID)
            }
        }

        return userUIDs
    }
}
