import UIKit

class AddTaskViewController: UIViewController {
    
    // UI Elements
    private let visibilityLabel = UILabel()
    private let visibilitySlider = UISlider()
    
    private let nameTextField = UITextField()
    private let unitTextField = UITextField()
    
    private let goalTextField = UITextField()
    private let frequencySegmentedControl = UISegmentedControl(items: ["Daily", "Weekly", "Monthly"])
    
    private let categoryLabel = UILabel()
    private let categoryStackView = UIStackView()
    
    private let saveButton = UIButton(type: .system)
    
    // Categories
    private let categories = ["Exercise", "Nutrition", "Productivity", "Social", "Finance"]
    private var selectedCategories = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Habit"
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // Visibility Slider
        visibilityLabel.text = "Visibility: Public"
        visibilitySlider.minimumValue = 0
        visibilitySlider.maximumValue = 1
        visibilitySlider.addTarget(self, action: #selector(visibilityChanged), for: .valueChanged)
        
        // Text Fields
        nameTextField.placeholder = "Enter habit name"
        unitTextField.placeholder = "Enter unit (e.g., Times, Glasses)"
        goalTextField.placeholder = "Enter goal number"
        goalTextField.keyboardType = .numberPad
        
        // Category Checkboxes
        categoryLabel.text = "Select Categories:"
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 5
        categories.forEach { category in
            let checkbox = UIButton(type: .system)
            checkbox.setTitle(category, for: .normal)
            checkbox.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(checkbox)
        }
        
        // Save Button
        saveButton.setTitle("Save Habit", for: .normal)
        saveButton.addTarget(self, action: #selector(saveHabit), for: .touchUpInside)
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [
            visibilityLabel, visibilitySlider,
            nameTextField, unitTextField,
            goalTextField, frequencySegmentedControl,
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
    @objc private func visibilityChanged() {
        visibilityLabel.text = visibilitySlider.value < 0.5 ? "Visibility: Public" : "Visibility: Private"
    }
    
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
    
    @objc private func saveHabit() {
        guard let name = nameTextField.text, !name.isEmpty,
              let unit = unitTextField.text, !unit.isEmpty,
              let goalText = goalTextField.text, let goal = Int(goalText) else {
            return
        }
        
        let frequency = frequencySegmentedControl.titleForSegment(at: frequencySegmentedControl.selectedSegmentIndex) ?? "Daily"
        
        let newHabit = Habit(
            name: name,
            isGroupHabit: false,
            category: selectedCategories.joined(separator: ", "),
            streak: 0,
            completed: 0,
            goal: goal,
            unit: unit,
            frequency: frequency
        )
        
        HabitManager.shared.addHabit(newHabit)
        
        navigationController?.popViewController(animated: true)
    }
}
