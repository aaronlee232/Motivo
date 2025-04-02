//
//  HabitModel.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/12/25.
//
import FirebaseFirestore

// This should be split into HabitModel which contains information about the metadata of a task and HabitRecord which contains the instances of that task being completed

struct HabitModel: Codable{
    @DocumentID var id: String!
    let name: String
    let isGroupHabit: Bool
    let category: String
    var streak: Int
    var completed: Int //To be moved to Record
    let goal: Int
    let unit: String
    let frequency: String
    
    // Computed property to check if a habit is fully completed, should move to habitrecord
    var isCompleted: Bool {
        return completed >= goal
    }
}

// Add HabitRecord
//id
//refToHabitModel
//completedCount
//unverifiedPhotosList
//timestamp
//isCompleted is computed by fetching goal from associated habit by hbait id
//is Pending is computed by checking if unverified photos list is populated

