//
//  AddHabitView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/6/25.
//
import UIKit

// Picker data
// TODO: move to a constants file later
let daysOfMonth = [Int](1...31)
let daysOfWeek = [Int](1...7)
let daysOfWeekFormatted = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var timesOfTheDay: [String] = {
    var list = [String]()
    for hour in 0..<24 {
        for minute in 0..<60 {
            list.append(String(format: "%02d:%02d", hour, minute))
        }
    }
    return list
}()

protocol AddHabitViewDelegate: AddHabitViewController {
    func didTapSaveHabit()
}

class AddHabitView: UIView, CategorySelectionViewDelegate {
    
    // MARK: - UI Elements
    private let titleLabel = BoldTitleLabel(textLabel: "Add Habit")
    private let visibilityLabel = UILabel()
    private let visibilitySegmentedControl = SegCtrl(items: ["Public", "Private"])
    let nameTextField = UITextField()
    let unitTextField = UITextField()
    let goalTextField = UITextField()
    let frequencySegmentedControl = SegCtrl(items: FrequencyConstants.frequencies)
    private let categoryLabel = UILabel()
    private let saveButton = UIButton(type: .system)
    let categorySelectionView = CategorySelectionView()
    let picker = UIPickerView()
    
    // MARK: - Properties
    var selectedCategories = Set<CategoryModel>()
    var delegate: AddHabitViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categorySelectionView.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension AddHabitView {
    private func setupUI() {
        titleLabel.textAlignment = .center
        
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
        
        addSubview(titleLabel)
        addSubview(stackView)
        addSubview(picker)
        addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        categorySelectionView.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        categorySelectionView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            categorySelectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
//            categorySelectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            categorySelectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categorySelectionView.heightAnchor.constraint(equalToConstant: 250),
            picker.leadingAnchor.constraint(equalTo: leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: trailingAnchor),
            picker.topAnchor.constraint(equalTo: categorySelectionView.bottomAnchor, constant: 20),
            
            saveButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
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
