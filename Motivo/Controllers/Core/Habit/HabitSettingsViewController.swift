//
//  SettingsViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//


import UIKit

class HabitSettingsViewController: UIViewController, HabitSettingsViewDelegate {

    private let habitSettingsView = HabitSettingsView()
    
    let habitManger = HabitManager()
    
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
    
    private func getStoredSelectedCategoryIDs() -> [String] {
        if let selectedCategoryIDs =
            UserDefaults.standard.array(forKey: UserDefaultKeys.selectedCategoryIDs) as? [String] {
            return selectedCategoryIDs
        }
        
        return []
    }
    
    private func loadCategoryOptions() {
        Task {
            do {
                // Fetch categories
                let categories = try await habitManger.fetchCategories()
                habitSettingsView.categorySelectionView.categories = categories
                
                // Retrieve previosly selected categories from user defaults
                let fetchedCategoriesByID = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
                let storedSelectedCategoryIDs = getStoredSelectedCategoryIDs()
                
                // Verify if they're still valid
                var isValid = true
                for storedCategoryID in storedSelectedCategoryIDs {
                    isValid = isValid && fetchedCategoriesByID.keys.contains(storedCategoryID)
                }
                
                // Apply stored selection if valid
                if (isValid) {
                    let storedCategories = storedSelectedCategoryIDs.map { fetchedCategoriesByID[$0]! }
                    habitSettingsView.categorySelectionView.selectedCategories = Set(storedCategories)
                } else {
                    // Remove stored categories if invalid
                    UserDefaults.standard.removeObject(forKey: UserDefaultKeys.selectedCategoryIDs)
                }
                
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
    }
}

extension HabitSettingsViewController {
    func didTapSaveSettings() {
        // Retrieve selected category IDs
        let selectedCategoryIDs = habitSettingsView.selectedCategories.map { $0.id }
        
        // Save selected categories to UserDefaults
        UserDefaults.standard.set(selectedCategoryIDs, forKey: UserDefaultKeys.selectedCategoryIDs)

        // Go back to main screen
        navigationController?.popViewController(animated: true)
    }
}
