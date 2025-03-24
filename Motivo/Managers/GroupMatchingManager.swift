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
    func insertGroup(group: GroupModel) throws -> String {
        return try FirestoreService.shared.addGroup(group: group)
    }
    
    // Inserts an instance of Group Membership Model into the group membership collection in Firestore
    func insertGroupMembership(membership: GroupMembershipModel) throws {
        try FirestoreService.shared.addGroupMembership(membership: membership)
    }
    
    // Fetch group based on groupID
    func fetchGroup(groupID: String) async throws -> GroupModel? {
        return try await FirestoreService.shared.fetchGroup(forGroupID: groupID)
    }
    
    // Check if there a user is a member of a group
    func isUserMemberOfGroup(with groupID: String, uid: String) async throws -> Bool {
        let membership = try await FirestoreService.shared.fetchGroupMembership(forGroupID: groupID, userUID: uid)
        return membership != nil
    }
    
    // Put a user into a random group based on selected categories
    func joinRandomGroup(with categories:[CategoryModel], as userUID:String) {
        // TODO: Implement join randomGroup
        // Fetch list of all groups that contain the categories
        // Pick random from list of groups
        // Create groupMembership doc
    }
}
