//
//  GroupMatchingManager.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/11/25.
//

import FirebaseFirestore

class GroupMatchingManager {
    
    let db = Firestore.firestore()
    
    // Inserts an instance of Group Model into the 'group' collection in Firestore
    func insertGroupDataAsync(group: GroupModel) async throws -> String {
        let groupCollectionRef = db.collection(FirestoreCollection.group)
        // let groupDocument = groupDocRef.document()
        let groupDocRef = try groupCollectionRef.addDocument(from: group).documentID
        return groupDocRef
    }
    
    // Inserts an instance of Group Membership Model into the group membership collection in Firestore
    func insertGroupMembership(membership: GroupMembershipModel) async throws {
        let groupMembershipDocument = db.collection(FirestoreCollection.groupMembership).document()
        try groupMembershipDocument.setData(from: membership)
    }
    
    func fetchGroup(groupId: String) async throws -> GroupModel? {
        let document = try await db.collection(FirestoreCollection.group).document(groupId).getDocument()
        
        guard document.exists else {
            print("Group document does not exist in Firestore")
            return nil
        }
        
        return try document.data(as: GroupModel.self)
    }
    
    func isMemberOfGroup(with groupId: String, uid: String) async throws -> Bool {
        let snapshot = try await db.collection(FirestoreCollection.groupMembership)
            .whereField("groupId", isEqualTo: groupId)
            .whereField("userUid", isEqualTo: uid)
            .getDocuments()
        print("snapshot.documents: \(snapshot.documents)")
        return !snapshot.documents.isEmpty
    }
}
