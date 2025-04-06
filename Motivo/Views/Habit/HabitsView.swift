import FirebaseFirestore

class HabitsView {
    private(set) var habits: [HabitModel] = []
    private(set) var habitRecords: [String: HabitRecord] = [:] // Map habit ID to its record
    let db = Firestore.firestore()

    init() {
        loadHabits()
        observeSettingsChanges()
    }

    private func observeSettingsChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadHabits), name: .didUpdateCategories, object: nil)
    }

    @objc func loadHabits() {
        db.collection(FirestoreCollection.habit).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching habits: \(error.localizedDescription)")
                return
            }

            self.habits = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return HabitModel(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    isGroupHabit: data["isGroupHabit"] as? Bool ?? false,
                    categoryIDs: data["category"] as! [String],
                    streak: data["streak"] as? Int ?? 0,
                    goal: data["goal"] as? Int ?? 0,
                    unit: data["unit"] as? String ?? "",
                    frequency: data["frequency"] as? String ?? "Daily",
                    userID: AuthManager.shared.getCurrentUserAuthInstance()?.uid ?? ""
                )
            } ?? []

            print("Loaded habits:", self.habits)

            // Fetch habit records after habits are loaded
            self.loadHabitRecords()
        }
    }

    
//    func testFetchHabits() {
//        db.collection("habits").getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error fetching habits: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("No documents found")
//                return
//            }
//
//            for doc in documents {
//                print("Document ID: \(doc.documentID) - Data: \(doc.data())")
//            }
//        }
//    }


    private func loadHabitRecords() {
        let habitIDs = habits.map { $0.id! }

        guard !habitIDs.isEmpty else {
            self.habitRecords = [:] // Clear records if no habits
            return
        }

        db.collection("habitRecords")
            .whereField("habitID", in: habitIDs)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching habit records: \(error.localizedDescription)")
                    return
                }

                self.habitRecords = snapshot?.documents.reduce(into: [:]) { (dict, doc) in
                    if let record = try? doc.data(as: HabitRecord.self) {
                        dict[record.habitID] = record
                    }
                } ?? [:]

                DispatchQueue.main.async {
                    self.sortHabits()
                    NotificationCenter.default.post(name: .didUpdateHabitRecords, object: nil) // Notify the UI
                }
            }
    }



    func sortHabits() {
        // Keep completed habits at the bottom
        habits.sort { (habit1, habit2) in
            let completed1 = habitRecords[habit1.id]?.isCompleted ?? false
            let completed2 = habitRecords[habit2.id]?.isCompleted ?? false
            return !completed1 && completed2
        }
    }

    func numberOfHabits() -> Int {
        return habits.count
    }

    func habit(at index: Int) -> HabitModel {
        return habits[index]
    }

    func habitRecord(for habitID: String) -> HabitRecord? {
        return habitRecords[habitID]
    }

    func updateHabitRecord(for habitID: String) {
        guard var record = habitRecords[habitID] else { return }
        record.completedCount += 1

        // Update Firestore
        db.collection("habitRecords").document(record.id).setData([
            "completedCount": record.completedCount
        ], merge: true) { error in
            if let error = error {
                print("Error updating habit record: \(error.localizedDescription)")
            }
        }

        habitRecords[habitID] = record
        sortHabits()
    }
}
