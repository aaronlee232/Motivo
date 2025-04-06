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
        
        // TODO: load categories into habitSettingsView.categorySelector.categories
        // TODO: implement constraints for habitSettingsView
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
