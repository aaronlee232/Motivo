//
//  AddHabitViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/10/25.
//

import UIKit
import FirebaseFirestore

class AddHabitViewController: UIViewController, AddHabitViewDelegate {

    // MARK: - UI Elements
    private var addHabitView = AddHabitView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Habit"
        view.backgroundColor = .systemBackground
        
        
        // TODO: Add loadCategories call and pass it to addHabitView.categorySelector.categories
        
        NSLayoutConstraint.activate([
            // TODO: add addHabbitView constraints
        ])
    }
}

// MARK: - AddHabitViewDelegate
extension AddHabitViewController {
    func didTapSaveHabit() {
        guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
            AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
            return
        }
        
        guard let name = addHabitView.nameTextField.text, !name.isEmpty,
              let unit = addHabitView.unitTextField.text, !unit.isEmpty,
              let goalText = addHabitView.goalTextField.text, let goal = Int(goalText) else {
            return
        }
        
        let selectedFrequencyIdx = addHabitView.frequencySegmentedControl.selectedSegmentIndex
        let frequency = addHabitView.frequencySegmentedControl.titleForSegment(at: selectedFrequencyIdx) ?? FrequencyConstants.daily

        let categoryIDs = addHabitView.selectedCategories.map { $0.id! }
        
        let newHabit = HabitModel(
            name: name,
            categoryIDs: categoryIDs,
            streak: 0,
            goal: goal,
            unit: unit,
            frequency: frequency,
            userID: user.uid
        )

        do {
            try FirestoreService.shared.addHabit(habit: newHabit)
            navigationController?.popViewController(animated: true)
            
        } catch {
            print("Error adding habit: \(error.localizedDescription)")
        }
    }
}
