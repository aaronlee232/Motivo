//
//  HabitModel.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/12/25.
//
import FirebaseFirestore

// This should be split into HabitModel which contains information about the metadata of a task and HabitRecord which contains the instances of that task being completed

struct HabitModel: Codable {
    @DocumentID var id: String!
    let name: String
    let isGroupHabit: Bool
    let category: [String]
    var streak: Int
    let goal: Int
    let unit: String
    let frequency: String
    let userID: String
}

struct HabitRecord: Codable {
    @DocumentID var id: String!
    let habitID: String
    var completedCount: Int
    var unverifiedPhotosList: [String]
    let timestamp: Timestamp
    let userID: String
    
    // Computed properties
    var isCompleted: Bool {
        return completedCount >= 3 // Fetch goal from HabitModel
    }
    
    var isPending: Bool {
        return !unverifiedPhotosList.isEmpty
    }
}

