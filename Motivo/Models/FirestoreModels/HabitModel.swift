//
//  HabitModel.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/12/25.
//
import FirebaseFirestore

struct Habit: Codable{
    @DocumentID var id: String?
    let name: String
    let isGroupHabit: Bool
    let category: String
    var streak: Int
    var completed: Int
    let goal: Int
    let unit: String
    let frequency: String
    
    // Computed property to check if a habit is fully completed
    var isCompleted: Bool {
        return completed >= goal
    }
}
