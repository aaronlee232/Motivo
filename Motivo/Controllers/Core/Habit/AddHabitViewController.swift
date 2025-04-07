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
        
        addHabitView.delegate = self
        view.addSubview(addHabitView)
        
        loadCategoryOptions()
        setupConstraints()
    }
    
    private func setupConstraints() {
        addHabitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addHabitView.topAnchor.constraint(equalTo: view.topAnchor),
            addHabitView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addHabitView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addHabitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadCategoryOptions() {
        Task {
            do {
                let categories = try await FirestoreService.shared.fetchCategories()
                addHabitView.categorySelectionView.categories = categories
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
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
            userUID: user.uid
        )

        do {
            try FirestoreService.shared.addHabit(habit: newHabit)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error adding habit: \(error.localizedDescription)")
        }
    }
}
