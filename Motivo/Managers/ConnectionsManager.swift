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
        return try await FirestoreService.shared.fetchUser(uid: uid)
    }
    
    // Uses a User's UID to fetch other related UserModels that are in shared group(s) with the user in FireStore.
    func fetchConnections(for uid: String) async throws -> [UserModel] {
        // Get group IDs where the user is a member
        let groupIDs = try await fetchUserGroupIDs(userUID: uid)
        guard !groupIDs.isEmpty else { return [] } // No groups found
        
        print(groupIDs)

        // Get user UIDs from those groups
        let userUIDs = try await fetchUsersFromGroups(groupIDs: groupIDs, excluding: uid)
        guard !userUIDs.isEmpty else { return [] } // No connected users
        
        print(userUIDs)

        // Fetch user details
        let users = try await fetchUsersByUIDs(userUIDs)
        return users
    }
    
    // Uses a User's UID to fetch the groupIDs for the groups that they are a member of in FireStore.
    private func fetchUserGroupIDs(userUID: String) async throws -> [String] {
        let snapshot = try await db.collection(FirestoreCollection.groupMembership)
            .whereField("userUID", isEqualTo: userUID)
            .getDocuments()
        
        
        
        
        let groupIDs = snapshot.documents.compactMap { document in document["groupID"] as? String }
        print(groupIDs)
        return groupIDs
    }
    
    // Uses groupIDs to retrieve a list of users that are in each of the corresponding groups of those groupIDs in FireStore.
    private func fetchUsersFromGroups(groupIDs: [String], excluding currentUID: String) async throws -> Set<String> {
        guard !groupIDs.isEmpty else { return [] } // Prevents Firestore from failing on empty queries

        let snapshot = try await db.collection(FirestoreCollection.groupMembership)
            .whereField("groupID", in: groupIDs)
            .getDocuments()

        var userUIDs = Set<String>()

        for document in snapshot.documents {
            if let userUID = document["userUID"] as? String, userUID != currentUID {
                userUIDs.insert(userUID)
            }
        }

        return userUIDs
    }

    // Retrieves the UserModel of the users that match the given userUIDs in FireStore.
    private func fetchUsersByUIDs(_ userUIDs: Set<String>) async throws -> [UserModel] {
        guard !userUIDs.isEmpty else { return [] } // Prevents Firestore from failing on empty queries

        let userSnapshot = try await db.collection(FirestoreCollection.user)
            .whereField(FieldPath.documentID(), in: Array(userUIDs))
            .getDocuments()

        return try userSnapshot.documents.compactMap { document in
            try document.data(as: UserModel.self)
        }
    }
    
}
