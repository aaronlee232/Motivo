//
//  HabitsViewModel.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/12/25.
//
import UIKit

// MARK: - Suggested TODO Items
/**
 Pretty much all of this needs to be moved into controller, where all the logic is stored.
 
 View should only hold the "skeleton" of visual elements.
 Configuring dynamic elements and elements that change (commonly in multi-screen views) should be done in the controller to conform to MVC file structure
 Data/State storage should be inside Model
 Data handling should be inside Manager
 
 These things should be done inside view:
 - Initializing UIViews like button = UIButton()
 - Unchanging properties of views (like a label that always says "Back") should also be set here.
 - Defining constraints
 
 Things that should NOT be done inside view:
 - populate dynamic content (if this needs to be done, move view-related dynamic content into its own separate view file, and add it dynamically as a subview to this file in the controller)
 - data management logic (sorting, counting, selecting, etc). Move this into Manager
 
 
 It would be nice if the file/class for HabitView was also kept consistent with the controllers. Rename everything to use habit or task so its consistent.
 */
import FirebaseFirestore

class HabitsView {
    private(set) var habits: [HabitModel] = []
    let db = Firestore.firestore()
    
    init() {
        loadHabits()
        observeSettingsChanges()
    }
    
    /**
        Observes changes in user settings (e.g., selected categories)
        and reloads habits accordingly.
     */
    private func observeSettingsChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadHabits), name: .didUpdateCategories, object: nil)
    }
    
    // Loads habits filtered by the selected categories
    @objc func loadHabits() {
            let selectedCategories = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] ?? ["Exercise", "Nutrition", "Productivity", "Social", "Finance"]

            db.collection("habits")
                .whereField("category", in: selectedCategories)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching habits: \(error.localizedDescription)")
                        return
                    }

                    self.habits = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: HabitModel.self)
                    } ?? []

                    self.sortHabits()
                }
        }
    
    func updateHabit(at index: Int) {
        guard index < habits.count else { return }
        
        if habits[index].completed == habits[index].goal - 1 {
            habits[index].streak += 1
        }
        
        habits[index].completed += 1
        sortHabits()
    }
    
    func sortHabits() {
        habits.sort { !$0.isCompleted && $1.isCompleted }
    }
    
    func numberOfHabits() -> Int {
        return habits.count
    }
    
    func habit(at index: Int) -> HabitModel {
        return habits[index]
    }
}
