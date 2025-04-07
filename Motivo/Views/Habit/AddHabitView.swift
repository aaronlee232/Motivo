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
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        addSubview(stackView)
        addSubview(saveButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            categorySelectionView.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            saveButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
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
