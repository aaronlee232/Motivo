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
        try FirestoreService.shared.updateHabitRecord(withHabitRecord: withHabitRecord)
    }
    
    // Uploads habit image to Firebase Storage
    func uploadHabitPhoto(image: UIImage) async throws -> URL {
        return try await StorageService.shared.uploadPhoto(image)
    }
    
    // Fetches the active habit record for each habit of the user. If a habit does not have an active record, one will be created for it.
    func fetchActiveHabitWithRecords(forUserUID userUID: String) async throws -> [HabitWithRecord] {
        var activeHabitEntries: [HabitWithRecord] = []
        
        // Fetch list of habits from user
        let habits = try await FirestoreService.shared.fetchHabits(forUserUID: userUID)
        
        // Get the active habit record for each habit of the user
        for habit in habits {
            // contains inactive and active record
            let records = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)
            let rawHabitEntries: [HabitWithRecord] = records.map {HabitWithRecord(habit: habit, record: $0) }
            
            let filteredHabitEntries = rawHabitEntries.filter { $0.isActive }
            
            // Sanity Check: there should only be one active record per habit
            if filteredHabitEntries.count > 1 {
                fatalError("This should not have happened. There should only be one active record per habit")
            }
            
            // If there is an active record, add it to the list of active habit records
            if !filteredHabitEntries.isEmpty {
                let activeHabitEntry = filteredHabitEntries.first!
                activeHabitEntries.append(activeHabitEntry)
            } else {
                // if there are no active habit records, create a new record in firestore and add it to list
                let newHabitRecord = HabitRecord(
                    habitID: habit.id,
                    unverifiedPhotoURLs: [],
                    verifiedPhotoURLs: [],
                    timestamp: ISO8601DateFormatter().string(from: Date()),
                    userUID: habit.userUID)
                let newActiveHabitRecord = try await addHabitRecord(habitRecord: newHabitRecord)
                activeHabitEntries.append(HabitWithRecord(habit: habit, record: newActiveHabitRecord))
            }
        }
        return activeHabitEntries
    }
}
