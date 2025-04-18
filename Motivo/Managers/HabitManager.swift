import FirebaseFirestore
//import FirebaseFirestoreSwift

class HabitManager {
    // Fetch habits from Firestore
    func fetchCategories() async throws -> [CategoryModel] {
        return try await FirestoreService.shared.fetchCategories()
    }
    
    // Fetch habits of userUID
    func fetchHabits(forUserUID: String) async throws -> [HabitModel] {
        return try await FirestoreService.shared.fetchHabits(forUserUID: forUserUID)
    }
      
    // Add a new habit to Firestore
    func addHabit(_ habit: HabitModel) throws {
        try FirestoreService.shared.addHabit(habit: habit)
    }
    
    // Fetch habit records of habitID
    func fetchHabitRecords(forHabitID: String) async throws -> [HabitRecord] {
        return try await FirestoreService.shared.fetchHabitRecords(forHabitID: forHabitID)
    }
    
    // Add a new habit record to Firestore
    func addHabitRecord(habitRecord: HabitRecord) async throws -> HabitRecord {
        return try await FirestoreService.shared.addHabitRecord(habitRecord: habitRecord)
    }
    
    // Update an existing habit record
    func updateHabitRecord(withHabitRecord: HabitRecord) async throws {
        try FirestoreService.shared.updateHabitRecord(habitRecord: withHabitRecord)
    }
    
    // Uploads habit image to Firebase Storage
    func uploadHabitPhoto(image: UIImage) async throws -> URL {
        return try await StorageService.shared.uploadPhoto(image)
    }
}
