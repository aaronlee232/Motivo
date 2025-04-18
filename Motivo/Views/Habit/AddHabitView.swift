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
//let daysOfWeek = [Int](1...7)
let daysOfWeek = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]
//var timesOfTheDay: [String] = {
//    var list = [String]()
//    for hour in 0..<24 {
//        for minute in 0..<60 {
//            list.append(String(format: "%02d:%02d", hour, minute))
//        }
//    }
//    return list
//}()
let hours = [Int](0..<24)
let minutes = [Int](0..<60)

protocol AddHabitViewDelegate: AddHabitViewController {
    func didTapSaveHabit()
}

class AddHabitView: UIView, CategorySelectionViewDelegate {
    
    // MARK: - UI Elements
    private let titleLabel = BoldTitleLabel(textLabel: "Add Habit")
    private let visibilityLabel = NormalLabel(textLabel: "Visibility")
    private let visibilitySegmentedControl = SegCtrl(items: ["Public", "Private"])
    let nameTextField = GreyTextField(placeholderText: "Enter habit name", isSecure: false)
    let unitTextField = GreyTextField(placeholderText: "Enter unit (e.g., Times, Glasses)", isSecure: false)
    let goalTextField = GreyTextField(placeholderText: "Enter goal number", isSecure: false)
    let frequencySegmentedControl = SegCtrl(items: FrequencyConstants.frequencies)
    private let deadlineLabel = NormalLabel(textLabel: "Deadline")
    let picker = UIPickerView()
    private let categoryLabel = NormalLabel(textLabel: "Select Categories:")
    private let saveButton = ActionButton(title: "SAVE HABIT")
    let categorySelectionView = CategorySelectionView()
    
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
//        visibilityLabel.text = "Visibility"
        visibilityLabel.textAlignment = .left
        visibilitySegmentedControl.selectedSegmentIndex = 0
        
        // Text Fields
//        nameTextField.placeholder = "Enter habit name"
//        unitTextField.placeholder = "Enter unit (e.g., Times, Glasses)"
//        goalTextField.placeholder = "Enter goal number"
        goalTextField.keyboardType = .numberPad
        
        // Frequency Selector
        frequencySegmentedControl.selectedSegmentIndex = 0
        
        // Category Checkboxes
//        categoryLabel.text = "Select Categories:"
        categoryLabel.textAlignment = .left
        
        deadlineLabel.textAlignment = .left
        
        // Save Button
//        saveButton.setTitle("Save Habit", for: .normal)
        saveButton.addTarget(self, action: #selector(handleDidTapSaveHabit), for: .touchUpInside)
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [
            visibilityLabel, visibilitySegmentedControl,
            nameTextField, unitTextField,
            goalTextField, frequencySegmentedControl,
            deadlineLabel, picker,
            categoryLabel, categorySelectionView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        addSubview(titleLabel)
        addSubview(stackView)
//        addSubview(picker)
        addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        categorySelectionView.translatesAutoresizingMaskIntoConstraints = false
//        picker.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        categorySelectionView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            picker.heightAnchor.constraint(equalToConstant: 150),
//            categorySelectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
//            categorySelectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            categorySelectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categorySelectionView.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
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
