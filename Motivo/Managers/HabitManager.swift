//
//  HabitManager.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/10/25.
//


import Foundation

class HabitManager {
    // TODO: I don't think this needs a singleton design pattern since we probably won't have app-wide references to this manager
    static let shared = HabitManager()
    
    private(set) var habits: [Habit] = HabitData.habits
    
    // TODO: Implement firestore methods here
    // TODO: If applicable, move data related methods from HabitsView here (ex: sortHabits)
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        sortHabits()
    }
    
    func sortHabits() {
        habits.sort { !$0.isCompleted && $1.isCompleted }
    }
}
