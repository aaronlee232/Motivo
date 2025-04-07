//
//  SettingsViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//


import UIKit

class HabitSettingsViewController: UIViewController, HabitSettingsViewDelegate {

    private let habitSettingsView = HabitSettingsView()
    
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
                let categories = try await FirestoreService.shared.fetchCategories()
                habitSettingsView.categorySelectionView.categories = categories
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
    }
}

extension HabitSettingsViewController {
    func didTapSaveSettings() {
        // Save selected categories to UserDefaults
        UserDefaults.standard.set(Array(habitSettingsView.selectedCategories), forKey: "selectedCategories")

        // Notify observers (HabitsView) about the update
        NotificationCenter.default.post(name: .didUpdateCategories, object: nil)

        // Go back to main screen
        navigationController?.popViewController(animated: true)
    }
}
