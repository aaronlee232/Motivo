import FirebaseFirestore
//import FirebaseFirestoreSwift

class HabitManager {
    // Fetch habits from Firestore
    func fetchHabits() async throws -> [HabitModel] {
        return try await FirestoreService.shared.fetchHabits()
    }
      
    // Add a new habit to Firestore
    func addHabit(_ habit: HabitModel) throws {
        try FirestoreService.shared.addHabit(habit: habit)
    }
    
    // Fetch habit records of habitID
    func fetchHabitRecords(habitID: String) async throws -> [HabitRecord] {
        return try await FirestoreService.shared.fetchHabitRecords(forHabitID: habitID)
    }
}
