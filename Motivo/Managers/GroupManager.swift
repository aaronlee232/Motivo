//
//  GroupManager.swift
//  Motivo
//
//  Created by Aaron Lee on 4/5/25.
//

class GroupManager {
    
    // Fetch group name using groupID
    func fetchGroupName(groupID: String) async throws -> String {
        let group = try await FirestoreService.shared.fetchGroup(withGroupID: groupID)
        return group?.groupName ?? "Unknown Group"
    }
    
    func fetchGroupMetadata(with withGroupID: String) async throws -> GroupMetadata {
        guard let group = try await FirestoreService.shared.fetchGroup(withGroupID: withGroupID) else {
            return GroupMetadata(groupID: "", groupName: "Unknown Group", categoryNames: [], memberCount: 0, habitsCount: 0)
        }
        let members = try await FirestoreService.shared.fetchGroupMemberships(forGroupID: withGroupID)
        let category = try await FirestoreService.shared.fetchCategories(withCategoryIDs: group.groupCategoryIDs)
//        let habits = try await FirestoreService.shared.fetchHabits(forUserUIDs: members.map {$0.userUID})
        
        let groupMetadata = GroupMetadata(
            groupID: group.id!,
            image: nil,  // TODO: Replace with groupImageURL once added
            groupName: group.groupName,
            categoryNames: category.map{ $0.name },
            memberCount: members.count,
            habitsCount: 0  // replace with habits.count
        )
        
        return groupMetadata
    }
    
    func fetchGroupMetadataList(withGroupIDs: [String]) async throws -> [GroupMetadata] {
        var groupMetadataList: [GroupMetadata] = []
        for groupID in withGroupIDs {
            groupMetadataList.append(try await fetchGroupMetadata(with: groupID))
        }
        
        return groupMetadataList
    }
    
    func fetchGroupMetadataList(forUserUID: String) async throws -> [GroupMetadata] {
        let memberships = try await FirestoreService.shared.fetchGroupMemberships(forUserUID: forUserUID)
        print(memberships)
        
        if memberships.count == 0 {
            return []
        }
        
        let groupIDs = memberships.map { $0.groupID }
        print(groupIDs)
        return try await fetchGroupMetadataList(withGroupIDs: groupIDs)
    }
    
    
}
