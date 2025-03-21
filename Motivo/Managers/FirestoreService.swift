//
//  FirestoreManager.swift
//  Motivo
//
//  Created by Aaron Lee on 3/20/25.
//

import FirebaseFirestore

class FirestoreService {
    // Singleton AuthManager
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    let userCollectionRef:CollectionReference
    let groupCollectionRef:CollectionReference
    let groupMembershipCollectionRef:CollectionReference
    
    init() {
        userCollectionRef = db.collection(FirestoreCollection.user)
        groupCollectionRef = db.collection(FirestoreCollection.group)
        groupMembershipCollectionRef = db.collection(FirestoreCollection.groupMembership)
    }
    
    enum FirestoreError: Error {
        case multipleMembershipsFound
    }
}

// MARK: - user collection
extension FirestoreService {
    // Convenience: retrieves a single user by UID
    func fetchUser(forUserUID userUID: String) async throws -> UserModel? {
        try await fetchUsers(forUserUIDs: [userUID]).first
    }
    
    // Retrieves a list of users for a list of user UIDs
    func fetchUsers(forUserUIDs userUIDs: [String]) async throws -> [UserModel] {
        let snapshot = try await userCollectionRef
            .whereField(FieldPath.documentID(), in: Array(userUIDs))
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: UserModel.self)
        }
    }
    
    // Inserts instance of UserModel into the 'user' collection in Firestore
    func addUser(user: UserModel) throws {
        let userDocument = userCollectionRef.document(user.id)
        try userDocument.setData(from: user)
    }
}

// MARK: - group collection
extension FirestoreService {
    // Convenience: retrieves a single group by group ID
    func fetchGroup(forGroupID groupID: String) async throws -> GroupModel? {
        try await fetchGroups(forGroupIDs: [groupID]).first
    }
    
    // Retrieves a list of groups for a list of group IDs
    func fetchGroups(forGroupIDs groupIDs: [String]) async throws -> [GroupModel] {
        let snapshot = try await groupCollectionRef
            .whereField(FieldPath.documentID(), in: groupIDs)
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: GroupModel.self)
        }
    }
    
    // Inserts an instance of Group Model into the 'group' collection in Firestore. Returns new group documentID
    func addGroup(group: GroupModel) throws -> String {
        return try groupCollectionRef.addDocument(from: group).documentID
    }
}

// MARK: - groupMembership collection
extension FirestoreService {
    // Fetches a unique GroupMembership document for a user and group pairing
    func fetchGroupMembership(forGroupID groupID: String, userUID: String) async throws -> GroupMembershipModel? {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("groupID", isEqualTo: groupID)
            .whereField("userUID", isEqualTo: userUID)
            .getDocuments()
        
        let documents = snapshot.documents
        if documents.count > 1 {
            throw FirestoreError.multipleMembershipsFound
        }

        guard let document = documents.first else {
            return nil
        }

        return try document.data(as: GroupMembershipModel.self)
    }
    
    // Convenience: retrieves a list of memberships for a single user UID
    func fetchGroupMemberships(forUserUID userUID: String) async throws -> [GroupMembershipModel] {
        try await fetchGroupMemberships(forUserUIDs: [userUID])
    }
    
    // Retrieves a list of memberships for a list of user UIDs
    func fetchGroupMemberships(forUserUIDs userUIDs: [String]) async throws -> [GroupMembershipModel] {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("userUID", in: userUIDs)
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: GroupMembershipModel.self)
        }
    }
    
    // Convenience: retrieves a list of memberships for a single group ID
    func fetchGroupMemberships(forGroupID groupID: String) async throws -> [GroupMembershipModel] {
        try await fetchGroupMemberships(forGroupIDs: [groupID])
    }
    
    // Retrieves a list of memberships for a list of group IDs
    func fetchGroupMemberships(forGroupIDs groupIDs: [String]) async throws -> [GroupMembershipModel] {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("groupID", in: groupIDs)
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: GroupMembershipModel.self)
        }
    }
    
    // Inserts an instance of Group Membership Model into the group membership collection in Firestore
    func addGroupMembership(membership: GroupMembershipModel) throws {
        let groupMembershipDocument = groupMembershipCollectionRef.document()
        try groupMembershipDocument.setData(from: membership)
    }
}


// MARK: - habit/task collection
extension FirestoreService {
}
