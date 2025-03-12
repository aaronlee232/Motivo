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
        let document = try await db.collection("user").document(uid).getDocument()
        
        guard document.exists else {
            print("User document does not exist in Firestore")
            return nil
        }
        
        return try document.data(as: UserModel.self)
    }
    
    // Uses a User's UID to fetch other related UserModels that are in shared group(s) with the user in FireStore.
    func fetchConnections(for uid: String) async throws -> [UserModel] {
        // Get group IDs where the user is a member
        let groupIds = try await fetchUserGroupIds(uid: uid)
        guard !groupIds.isEmpty else { return [] } // No groups found
        print("test user groups: \(groupIds)")

        // Get user UIDs from those groups
        let userUids = try await fetchUsersFromGroups(groupIds: groupIds, excluding: uid)
        guard !userUids.isEmpty else { return [] } // No connected users
        print("other user ids in groups: \(userUids)")

        // Fetch user details
        let users = try await fetchUsersByUids(userUids)
        return users
    }
    
    // Uses a User's UID to fetch the groupIds for the groups that they are a member of in FireStore.
    private func fetchUserGroupIds(uid: String) async throws -> [String] {
        let snapshot = try await db.collection("group_membership")
            .whereField("userUid", isEqualTo: uid)
            .getDocuments()

        let groupIds = snapshot.documents.compactMap { document in document["groupId"] as? String }
        return groupIds
    }
    
    // Uses groupIds to retrieve a list of users that are in each of the corresponding groups of those groupIds in FireStore.
    private func fetchUsersFromGroups(groupIds: [String], excluding currentUid: String) async throws -> Set<String> {
        guard !groupIds.isEmpty else { return [] } // Prevents Firestore from failing on empty queries

        let snapshot = try await db.collection("group_membership")
            .whereField("groupId", in: groupIds)
            .getDocuments()

        var userUids = Set<String>()

        for document in snapshot.documents {
            if let userUid = document["userUid"] as? String, userUid != currentUid {
                userUids.insert(userUid)
            }
        }

        return userUids
    }

    // Retrieves the UserModel of the users that match the given userUids in FireStore.
    private func fetchUsersByUids(_ userUids: Set<String>) async throws -> [UserModel] {
        guard !userUids.isEmpty else { return [] } // Prevents Firestore from failing on empty queries

        let userSnapshot = try await db.collection("user")
            .whereField(FieldPath.documentID(), in: Array(userUids))
            .getDocuments()

        return try userSnapshot.documents.compactMap { document in
            try document.data(as: UserModel.self)
        }
    }
    
}
