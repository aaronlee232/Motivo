//
//  SettingsViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//


import UIKit

class HabitSettingsViewController: UIViewController {
    // TODO: Move these UIView initializations into a TaskSettingsView.swift file to conform with MVC
    // UI Elements
    private let notificationsToggle = UISwitch()
    private let notificationsLabel = UILabel()
    
    private let viewModeToggle = UISegmentedControl(items: ["Weekly", "Monthly"])
    private let viewModeLabel = UILabel()
    
    private let categoryLabel = UILabel()
    private let categoryStackView = UIStackView()
    
    private let saveButton = UIButton(type: .system)
    
    // Categories
    private let categories = ["Exercise", "Nutrition", "Productivity", "Social", "Finance"]
    private var selectedCategories = Set<String>(["Exercise", "Nutrition", "Productivity", "Social", "Finance"]) // Default: All selected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white
        setupUI()
    }
    
    // TODO: Move into TaskSettingsView.swift to conform with MVC. Create another View for category checkboxes if needed.
    private func setupUI() {
        // Notifications Toggle
        notificationsLabel.text = "Enable Push Notifications"
        notificationsToggle.isOn = false
        
        // View Mode Toggle (Weekly/Monthly)
        viewModeLabel.text = "View Mode"
        viewModeToggle.selectedSegmentIndex = 0
        
        // Category Checkboxes
        categoryLabel.text = "Select Categories:"
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 5
        categories.forEach { category in
            let checkbox = UIButton(type: .system)
            checkbox.setTitle(category, for: .normal)
            checkbox.tintColor = .blue
            checkbox.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(checkbox)
        }
        
        // Save Button
        saveButton.setTitle("Save Settings", for: .normal)
        saveButton.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [
            notificationsLabel, notificationsToggle,
            viewModeLabel, viewModeToggle,
            categoryLabel, categoryStackView,
            saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let category = sender.titleLabel?.text else { return }
        
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
            sender.tintColor = .gray
        } else {
            selectedCategories.insert(category)
            sender.tintColor = .blue
        }
    }
    
    @objc private func saveSettings() {
        // Save selected categories to UserDefaults
        UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")

        // Notify observers (HabitsView) about the update
        NotificationCenter.default.post(name: .didUpdateCategories, object: nil)

        // Go back to main screen
        navigationController?.popViewController(animated: true)
    }
}
