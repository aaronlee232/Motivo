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
    let categoryIDs: [String]
    var streak: Int
    let goal: Int
    let unit: String
    let frequency: String
    let deadline: String
    let userUID: String
    
    // Deadline property
    // "HH:mm" for daily (e.g. "23:00")
    // "weekday" ("1" ... "7") for weekly
    // "day of month" ("1"..."31") for monthly (e.g. "15" = 15th)
}

struct HabitRecord: Codable {
    @DocumentID var id: String!
    let habitID: String
    var unverifiedPhotoURLs: [String]
    var verifiedPhotoURLs: [String]
    let timestamp: String
    let userUID: String
    
    var completedCount: Int {
        return verifiedPhotoURLs.count
    }
    
    var pendingCount: Int {
        return unverifiedPhotoURLs.count
    }
    
    var isPending: Bool {
        return !unverifiedPhotoURLs.isEmpty
    }
}

