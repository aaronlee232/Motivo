//
//  AddHabitView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/6/25.
//
import UIKit

protocol AddHabitViewDelegate: AddHabitViewController {
    func didTapSaveHabit()
}

class AddHabitView: UIView, CategorySelectionViewDelegate {
    
    // MARK: - UI Elements
    let visibilityLabel = UILabel()
    let visibilitySegmentedControl = UISegmentedControl(items: ["Public", "Private"])
    let nameTextField = UITextField()
    let unitTextField = UITextField()
    let goalTextField = UITextField()
    let frequencySegmentedControl = UISegmentedControl(items: FrequencyConstants.frequencies)
    let categoryLabel = UILabel()
    let saveButton = UIButton(type: .system)
    let categorySelectionView = CategorySelectionView()
    
    // MARK: - Properties
    var selectedCategories = Set<CategoryModel>()
    var delegate: AddHabitViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension AddHabitView {
    private func setupUI() {
        // Visibility Selector
        visibilityLabel.text = "Visibility"
        visibilitySegmentedControl.selectedSegmentIndex = 0
        
        // Text Fields
        nameTextField.placeholder = "Enter habit name"
        unitTextField.placeholder = "Enter unit (e.g., Times, Glasses)"
        goalTextField.placeholder = "Enter goal number"
        goalTextField.keyboardType = .numberPad
        
        // Category Checkboxes
        categoryLabel.text = "Select Categories:"
        
        // Save Button
        saveButton.setTitle("Save Habit", for: .normal)
        saveButton.addTarget(self, action: #selector(handleDidTapSaveHabit), for: .touchUpInside)
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [
            visibilityLabel, visibilitySegmentedControl,
            nameTextField, unitTextField,
            goalTextField, frequencySegmentedControl,
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
    
    @objc private func handleDidTapSaveHabit() {
        delegate?.didTapSaveHabit()
    }
}

// MARK: - CategorySelectorViewDelegate
extension AddHabitView {
    func didUpdateSelectedCategories(_ selectedCategories: Set<CategoryModel>) {
        self.selectedCategories = selectedCategories
    }
}
