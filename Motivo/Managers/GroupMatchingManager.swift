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
    
    // Fetches the list of all categories
    func fetchCategories() async throws -> [CategoryModel] {
        return try await FirestoreService.shared.fetchCategories()
    }
    
    // Put a user into a random group based on selected categories. Creates group if no group with categories exist
    func joinRandomGroup(with categories:[CategoryModel], as userUID:String) async throws {
        // Extract categoryIDs
        let categoryIDs = categories.map { category in
            return category.id!
        }
        print("selected categories: \(categoryIDs)")
        
        // Fetch list of all groups that contain the categories
        var joinableGroups = try await FirestoreService.shared.fetchGroups(withCategoryIDs: categoryIDs)
        print("joinable groups: \(joinableGroups)")
        
        // filter out groups that the user is currently in
        let userMemberships = try await FirestoreService.shared.fetchGroupMemberships(forUserUID: userUID)
        let userGroupIDs = Set(userMemberships.map { membership in
            return membership.groupID
        })
        joinableGroups = joinableGroups.filter { group in
            return !userGroupIDs.contains(group.id!)
        }
        print("joinable groups (after filtering for already joined): \(joinableGroups)")
        
        // Pick a group for user to join
        let selectedGroupId: String
        if !joinableGroups.isEmpty {
            print("joinable groups not empty")
            // Case 1: Groups with matching categories found. Pick random to join
            let randomGroupIdx = (Int.random(in: 0..<joinableGroups.count))
            selectedGroupId = joinableGroups[randomGroupIdx].id!
        } else {
            // Case 2: No groups with matching categories, create a new group to join
            print("joinable groups are empty")
            let defaultName = "Random Group"
            let newGroup = GroupModel(groupName: defaultName, groupCategoryIDs: categoryIDs, creatorUID: userUID)
            selectedGroupId = try insertGroup(group: newGroup)
        }
        
        // Create and insert groupMembership doc
        print("selected group: \(selectedGroupId)")
        let membership = GroupMembershipModel(groupID: selectedGroupId, userUID: userUID)
        try insertGroupMembership(membership: membership)
    }
}
