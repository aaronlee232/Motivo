//
//  ProfileManager.swift
//  Motivo
//
//  Created by Aaron Lee on 4/20/25.
//

struct HabitPhotoData {
    let habit: HabitModel
    var imageURLs: [String]
}

class ProfileManager {
    
    func fetchCurrentUsername(forUserUID userUID: String) async throws -> String {
        guard let user = try await FirestoreService.shared.fetchUser(forUserUID: userUID) else {
            throw FetchError.runtimeError("Failed to fetch user with userUID \(userUID)")
        }
        return user.username
    }
    
    func fetchHabits(forUserUID userUID: String) async throws -> [HabitModel] {
        let habits = try await FirestoreService.shared.fetchHabits(forUserUID: userUID)
        return habits
    }
    
    func fetchGroupMetadataList(forUserUID userUID: String) async throws -> [GroupMetadata] {
        let groupManager = GroupManager()
        return try await groupManager.fetchGroupMetadataList(forUserUID: userUID)
    }
    
    func fetchHabitsWithVerifiedImageURLs(forUserUID userUID: String) async throws -> [HabitPhotoData] {
        let habits = try await FirestoreService.shared.fetchHabits(forUserUID: userUID)
        
        var habitsWithImages: [HabitPhotoData] = []
        for habit in habits {
            var habitPhotoData = HabitPhotoData(habit: habit, imageURLs: [])
            
            let records = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)
            for record in records {
                habitPhotoData.imageURLs.append(contentsOf: record.verifiedPhotoURLs)
            }
            habitsWithImages.append(habitPhotoData)
        }
        
        return habitsWithImages
    }
    
    func fetchCompletedHabitWithRecords(forUserUID userUID: String) async throws -> [HabitWithRecord] {
        let habits = try await FirestoreService.shared.fetchHabits(forUserUID: userUID)
        
        var completedHabitWithRecords: [HabitWithRecord] = []
        for habit in habits {
            let records = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)
            
            for record in records {
                let habitWithRecord = HabitWithRecord(habit: habit, record: record)
                if habitWithRecord.isCompleted {
                    completedHabitWithRecords.append(habitWithRecord)
                }
            }
        }
        
        return completedHabitWithRecords
    }
}
