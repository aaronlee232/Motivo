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
        var groupCollectionRef = db.collection("group")
        // let groupDocument = groupDocRef.document()
        let groupDocRef = try groupCollectionRef.addDocument(from: group).documentID
        return groupDocRef
    }
    
    // Inserts an instance of Group Membership Model into the 'group_membership' collection in Firestore
    func insertGroupMembership(membership: GroupMembershipModel) async throws {
        let groupMembershipDocument = db.collection("group_membership").document()
        try groupMembershipDocument.setData(from: membership)
    }
}
