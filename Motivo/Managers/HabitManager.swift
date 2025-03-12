import Foundation

class HabitManager {
    static let shared = HabitManager()
    
    private(set) var habits: [Habit] = HabitData.habits
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        sortHabits()
    }
    
    func sortHabits() {
        habits.sort { !$0.isCompleted && $1.isCompleted }
    }
}
