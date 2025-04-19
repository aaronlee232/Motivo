//
//  VerificationManager.swift
//  Motivo
//
//  Created by Aaron Lee on 4/19/25.
//

import Foundation

class VerificationManager {
    func addVote(_ vote: VoteModel) throws {
        try FirestoreService.shared.addVote(vote: vote)
    }
    
    func approvePhoto(withPhotoURL photoURL: String, forHabitRecordID habitRecordID: String) async throws {
        guard var habitRecord = try await FirestoreService.shared.fetchHabitRecord(forHabitRecordID: habitRecordID)
        else {
            enum FetchError: Error {
                case runtimeError(String)
            }
            throw FetchError.runtimeError("HabitRecord with ID \(habitRecordID) not found")
        }
                
        // Move photoURL to verified list
        if let i = habitRecord.unverifiedPhotoURLs.firstIndex(of: photoURL) {
            habitRecord.unverifiedPhotoURLs.remove(at: i)
            habitRecord.verifiedPhotoURLs.append(photoURL)
        } else {
            print("Photo with url: \(photoURL) not found in habit record with ID: \(habitRecordID)")
            return
        }
        
        // Update record in firestore
        try FirestoreService.shared.updateHabitRecord(withHabitRecord: habitRecord)
    }
}
