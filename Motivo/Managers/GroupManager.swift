//
//  GroupManager.swift
//  Motivo
//
//  Created by Aaron Lee on 4/5/25.
//

import Foundation

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
        let habits = try await FirestoreService.shared.fetchHabits(forUserUIDs: members.map {$0.userUID})
        
        let groupMetadata = GroupMetadata(
            groupID: group.id!,
            image: nil,  // TODO: Replace with groupImageURL once added
            groupName: group.groupName,
            categoryNames: category.map{ $0.name },
            memberCount: members.count,
            habitsCount: habits.count
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

        if memberships.count == 0 {
            return []
        }
        
        let groupIDs = memberships.map { $0.groupID }

        return try await fetchGroupMetadataList(withGroupIDs: groupIDs)
    }
    
    func fetchGroupUsers(forGroupID groupID: String) async throws -> [UserModel] {
        let group = try await FirestoreService.shared.fetchGroup(withGroupID: groupID)
        let memberships = try await FirestoreService.shared.fetchGroupMemberships(forGroupID: groupID)
        let userUIDs = memberships.map { $0.userUID }
        let users = try await FirestoreService.shared.fetchUsers(forUserUIDs: userUIDs)
        
        return users
    }
    
    func fetchUserHabits(forUserUID userUIDs: [String], withCategoryIDs categoryIDs: [String]) async throws -> [HabitModel] {
        return try await FirestoreService.shared.fetchHabits(forUserUIDs: userUIDs, forCategoryIDs: categoryIDs)
    }
    
    func fetchProgressCells(forGroupID groupID: String) async throws -> [ProgressCell] {
        let group = try await FirestoreService.shared.fetchGroup(withGroupID: groupID)
        let memberships = try await FirestoreService.shared.fetchGroupMemberships(forGroupID: groupID)
        let userUIDs = memberships.map { $0.userUID }
        let users = try await FirestoreService.shared.fetchUsers(forUserUIDs: userUIDs)
        
        // fetch list of habits for each user that fall under group categories
        var progressCells: [ProgressCell] = []
        for user in users {
            var activeHabitEntries: [HabitWithRecord] = []
            
            // Fetch list of habits from user that fall under group categories
            let habits = try await FirestoreService.shared.fetchHabits(forUserUID: user.id, forCategoryIDs: group!.groupCategoryIDs)
            
            // Get the active habit record for each habit of the user
            for habit in habits {
                // contains inactive and active record
                let records = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)
                let rawHabitEntries: [HabitWithRecord] = records.map {HabitWithRecord(habit: habit, record: $0) }
                
                let filteredHabitEntries = rawHabitEntries.filter { $0.isActive }
                
                // Sanity Check: there should only be one active record per habit
                if filteredHabitEntries.count > 1 {
                    fatalError("This should not have happened. There should only be one active record per habit")
                }
                
                // Set activehabitEntry
                var activeHabitEntry: HabitWithRecord
                
                // If there is no active record, create a local "empty record"
                if filteredHabitEntries.isEmpty {
                    let incompleteRecord = HabitRecord(
                        habitID: habit.id,
                        unverifiedPhotoURLs: [],
                        verifiedPhotoURLs: [],
                        timestamp: ISO8601DateFormatter().string(from: Date()),
                        userUID: user.id
                    )
                    
                    activeHabitEntry = HabitWithRecord(habit: habit, record: incompleteRecord)
                } else {
                    // If there is an active record, use it instead
                    activeHabitEntry = filteredHabitEntries.first!
                }
                activeHabitEntries.append(activeHabitEntry)
            }
            
            // Sort activeHabitEntries to be based on completion status
            activeHabitEntries.sort { $0.status < $1.status }
            
            // Create and return progress cell
            progressCells.append(ProgressCell(opened: false, name: user.username, habitEntries: activeHabitEntries))
        }
        return progressCells
    }
    
    func fetchCategories(forGroupID groupID: String) async throws -> [CategoryModel] {
        let group = try await FirestoreService.shared.fetchGroup(withGroupID: groupID)
        let categories = try await FirestoreService.shared.fetchCategories(withCategoryIDs: group!.groupCategoryIDs)
        return categories
    }
}
