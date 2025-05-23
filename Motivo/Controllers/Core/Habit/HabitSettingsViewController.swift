//
//  SettingsViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//


import UIKit

class HabitSettingsViewController: UIViewController, HabitSettingsViewDelegate {

    private let habitSettingsView = HabitSettingsView()
    
    let habitManager = HabitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        habitSettingsView.delegate = self
        view.addSubview(habitSettingsView)
        
        loadCategoryOptions()
        setupConstraints()
    }
    
    private func setupConstraints() {
        habitSettingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitSettingsView.topAnchor.constraint(equalTo: view.topAnchor),
            habitSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitSettingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadCategoryOptions() {
        Task {
            do {
                // Fetch categories
                let categories = try await habitManager.fetchCategories()
                
                // Retrieve stored selected frequency and categories from user defaults
                let storedSelectedCategories = habitManager.getStoredSelectedCategories(fromCategories: categories)
                let storedFrequencyIndex = habitManager.getStoredSelectedFrequencyIndex()
                
                habitSettingsView.configure(
                    withCategories: categories,
                    withSelectedCategories: storedSelectedCategories,
                    withFrequencyIndex: storedFrequencyIndex
                )
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
    }
}

extension HabitSettingsViewController {
    func didTapSaveSettings() {
        // Retrieve selected frequency and category IDs
        let selectedCategoryIDs = habitSettingsView.selectedCategories.map { $0.id }
        let selectedFrequencyIndex = habitSettingsView.frequencySelectionSegCtrl.selectedSegmentIndex
        let selectedFrequency = FrequencyConstants.frequencyFilterOptions[selectedFrequencyIndex]
        
        // Save selected categories to UserDefaults
        UserDefaults.standard.set(selectedCategoryIDs, forKey: UserDefaultKeys.selectedCategoryIDs)
        UserDefaults.standard.set(selectedFrequency, forKey: UserDefaultKeys.selectedFrequency)

        // Go back to main screen
        navigationController?.popViewController(animated: true)
    }
}
