//
//  HabitSettingsView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/6/25.
//

import UIKit


protocol HabitSettingsViewDelegate: HabitSettingsViewController {
    func didTapSaveSettings()
}


class HabitSettingsView: UIView, CategorySelectionViewDelegate {
    
    // UI Elements
    let notificationsToggle = UISwitch()
    let notificationsLabel = UILabel()
    let viewModeToggle = UISegmentedControl(items: [FrequencyConstants.weekly, FrequencyConstants.monthly])
    let viewModeLabel = UILabel()
    let categoryLabel = UILabel()
    let categorySelectionView = CategorySelectionView()
    let saveButton = UIButton(type: .system)
    
    // MARK: - Properties
    var selectedCategories = Set<CategoryModel>()
    var delegate: HabitSettingsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HabitSettingsView {
    private func setupUI() {
        // Notifications Toggle
        notificationsLabel.text = "Enable Push Notifications"
        notificationsToggle.isOn = false
        
        // View Mode Toggle (Weekly/Monthly)
        viewModeLabel.text = "View Mode"
        viewModeToggle.selectedSegmentIndex = 0
        
        // Category Checkboxes
        categoryLabel.text = "Select Categories:"
        
        // Save Button
        saveButton.setTitle("Save Settings", for: .normal)
        saveButton.addTarget(self, action: #selector(handleDidTapSaveSettings), for: .touchUpInside)
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [
            notificationsLabel, notificationsToggle,
            viewModeLabel, viewModeToggle,
            categoryLabel, categorySelectionView,
            saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    @objc private func handleDidTapSaveSettings() {
        delegate?.didTapSaveSettings()
    }
}

// MARK: - CategorySelectionViewDelegate
extension HabitSettingsView {
    func didUpdateSelectedCategories(_ selectedCategories: Set<CategoryModel>) {
        self.selectedCategories = selectedCategories
    }
}
