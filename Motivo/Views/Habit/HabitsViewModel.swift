////
////  HabitsViewModel.swift
////  Motivo
////
////  Created by Cooper Wilk on 4/2/25.
////
//
//import Foundation
//
//class HabitsViewModel {
//    
//    private(set) var habits: [HabitModel] = []
//    
//    init() {
//        loadHabits()
//    }
//    
//    func loadHabits() {
//        let selectedCategories = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] ?? ["Exercise", "Nutrition", "Productivity", "Social", "Finance"]
//        
//        habits = HabitData.habits
//            .filter { selectedCategories.contains($0.category) }
//            .sorted { !$0.isCompleted && $1.isCompleted }
//    }
//    
//    func updateHabit(at index: Int) {
//        guard index < habits.count else { return }
//        
//        if habits[index].completed == habits[index].goal - 1 {
//            habits[index].streak += 1
//        }
//        
//        habits[index].completed += 1
//        sortHabits()
//    }
//    
//    func sortHabits() {
//        habits.sort { !$0.isCompleted && $1.isCompleted }
//    }
//    
//    func numberOfHabits() -> Int {
//        return habits.count
//    }
//    
//    func habit(at index: Int) -> HabitModel {
//        return habits[index]
//    }
//}
