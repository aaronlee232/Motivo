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
    
    // Fetches the active habit record for each habit of the user. Also fetches associated reject votes for record
    // If a habit does not have an active record, one will be created for it.
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
            
            // If there is an active record, add it to the list of active habit records after fetching it's reject votes
            if !filteredHabitEntries.isEmpty {
                var activeHabitEntry = filteredHabitEntries.first!
                let rejectVotes = try await fetchRejectVotes(forRecordID: activeHabitEntry.record.id)
                
                var pendingRejectVotes: [VoteModel] = []
                let imageURLSet = Set(activeHabitEntry.record.unverifiedPhotoURLs)
                for vote in rejectVotes {
                    // Safety check to ensure votes are for displayed images
                    if (!imageURLSet.contains(vote.photoURL)) {
                        continue
                    }
                    
                    pendingRejectVotes.append(vote)
                }
                
                activeHabitEntry.rejectVotes = pendingRejectVotes
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
    
    func fetchRejectVotes(forRecordID recordID: String) async throws -> [VoteModel] {
        return try await FirestoreService.shared.fetchRejectVotes(forRecordID: recordID)
    }
    
    func getStoredSelectedCategoryIDs(fromCategories categories: [CategoryModel]) -> [String] {
        // Retrieve selected category ids from user defaults. return full category selection if not found
        guard let storedSelectedCategoryIDs =
            UserDefaults.standard.array(forKey: UserDefaultKeys.selectedCategoryIDs) as? [String] else {
            return categories.map { $0.id }
        }
        
        // Create dictionary entries for category by id for quick lookup
        let categoriesByID = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        
        // Verify if all stored category IDs are valid.
        for storedCategoryID in storedSelectedCategoryIDs {
            if !categoriesByID.keys.contains(storedCategoryID) {
                // Wipe from userdefault and return full category list if not valid
                UserDefaults.standard.removeObject(forKey: UserDefaultKeys.selectedCategoryIDs)
                return categories.map { $0.id }
            }
        }
        return storedSelectedCategoryIDs
    }
    
    func getStoredSelectedCategories(fromCategories categories: [CategoryModel]) -> [CategoryModel] {
        let storedSelectedCategoryIDs = getStoredSelectedCategoryIDs(fromCategories: categories)
        
        // Create dictionary entries for category by id for quick lookup
        let categoriesByID = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        
        // Get the category model from ID
        let storedCategories = storedSelectedCategoryIDs.map { categoriesByID[$0]! }
        return storedCategories
    }
    
    func getStoredSelectedFrequencyIndex() -> Int {
        // Retrieve selected frequency from user defaults. return index of 0 for "all" frequencies if not found
        guard let storedFrequency = UserDefaults.standard.string(forKey: UserDefaultKeys.selectedFrequency),
              FrequencyConstants.frequencies.contains(storedFrequency) else {
            return 0
        }
        
        let frequencyIndex = FrequencyConstants.frequencyFilterOptions.firstIndex(of: storedFrequency)!
        return frequencyIndex
    }
    
    func getStoredSelectedFrequency() -> String {
        let storedSelectedFrequencyIndex = getStoredSelectedFrequencyIndex()
        let frequency = FrequencyConstants.frequencyFilterOptions[storedSelectedFrequencyIndex]
        return frequency
    }
    
    func deleteHabitAndRecords(forHabitID habitID: String) async throws {
        try await FirestoreService.shared.deleteHabitAndRecords(forHabitID: habitID)
    }
}
