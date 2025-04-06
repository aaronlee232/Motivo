import FirebaseFirestore
//import FirebaseFirestoreSwift

class HabitManager {
    static let shared = HabitManager()
    
    private var db = Firestore.firestore()
    private(set) var habits: [HabitModel] = []
    
    // Fetch habits from Firestore
    func loadHabits(completion: @escaping () -> Void) {
        db.collection(FirestoreCollection.habit).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching habits: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.habits = documents.compactMap { doc in
                try? doc.data(as: HabitModel.self) // Assumes Habit conforms to Codable
            }
            
            self.sortHabits()
            completion() // Notify UI to refresh
        }
    }
    
    // Add a new habit to Firestore
    func addHabit(_ habit: HabitModel, completion: @escaping (Bool) -> Void) {
        do {
            let _ = try db.collection(FirestoreCollection.habit).addDocument(from: habit)
            self.habits.append(habit)
            self.sortHabits()
            completion(true)
        } catch {
            print("Error adding habit: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func sortHabits() {
//        habits.sort { !$0.isCompleted && $1.isCompleted }
    }
}
