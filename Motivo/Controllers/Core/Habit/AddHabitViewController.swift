//
//  AddHabitViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/10/25.
//

import UIKit
import FirebaseFirestore

class AddHabitViewController: UIViewController, AddHabitViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UI Elements
    private var addHabitView = AddHabitView()
    private var addHabitScrollableView = UIScrollView()
    
    private var pickerData: [[String]] = [] // list of lists to create multiple columns (hh:mm)

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Add Habit"
        view.backgroundColor = .systemBackground
        
        addHabitView.delegate = self
        view.addSubview(addHabitScrollableView)
        addHabitScrollableView.addSubview(addHabitView)
//        view.addSubview(addHabitView)
        addHabitView.picker.delegate = self
        addHabitView.picker.dataSource = self
        
        addHabitView.frequencySegmentedControl.addTarget(self, action: #selector(didSelectFrequency), for: .valueChanged)
        pickerData = [hours.map { String(format: "%02d", $0) }, [":"], minutes.map { String(format: "%02d", $0) }]
        
        loadCategoryOptions()
        setupConstraints()
    }
    
    private func setupConstraints() {
        addHabitScrollableView.translatesAutoresizingMaskIntoConstraints = false
        addHabitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addHabitScrollableView.topAnchor.constraint(equalTo: view.topAnchor),
            addHabitScrollableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addHabitScrollableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addHabitScrollableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addHabitView.topAnchor.constraint(equalTo: addHabitScrollableView.topAnchor),
            addHabitView.leadingAnchor.constraint(equalTo: addHabitScrollableView.leadingAnchor),
            addHabitView.trailingAnchor.constraint(equalTo: addHabitScrollableView.trailingAnchor),
            addHabitView.bottomAnchor.constraint(equalTo: addHabitScrollableView.bottomAnchor),
            addHabitView.widthAnchor.constraint(equalTo: addHabitScrollableView.widthAnchor)
        ])
    }
    
    private func loadCategoryOptions() {
        Task {
            do {
                let categories = try await FirestoreService.shared.fetchCategories()
                addHabitView.categorySelectionView.categories = categories
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
    }
    
    @objc private func didSelectFrequency() {
        let selectedIndex = addHabitView.frequencySegmentedControl.selectedSegmentIndex
        guard let selectedFrequency = addHabitView.frequencySegmentedControl.titleForSegment(at: selectedIndex) else {
            return
        }
        addHabitView.picker.isHidden = true
        addHabitView.picker.selectRow(0, inComponent: 0, animated: false) // resets to the first element in the picker
        switch selectedFrequency {
        case FrequencyConstants.daily:
            pickerData = [hours.map { String(format: "%02d", $0) }, [":"], minutes.map { String(format: "%02d", $0) }]
            addHabitView.picker.isHidden = false
        case FrequencyConstants.weekly:
            pickerData = []
            var data:[String] = []
            for day in 1 ... daysOfWeek.count {
                data.append(daysOfWeek[day]!)
            }
            pickerData.append(data)
            addHabitView.picker.isHidden = false
        case FrequencyConstants.monthly:
            pickerData = [daysOfMonth.map { "Day \($0)" }]
            addHabitView.picker.isHidden = false
        default:
            pickerData = []
        }
        addHabitView.picker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // for the ":"
        if component == 1 {
            return 30
        } else {
            return pickerView.frame.width / CGFloat(pickerData.count)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int) -> UIView? {
        let label = NormalLabel(textLabel: pickerData[component][row])
        label.textAlignment = .center
        return label
   }
}

// MARK: - AddHabitViewDelegate
extension AddHabitViewController {
    func didTapSaveHabit() {
        guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
            AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
            return
        }
        
        guard let name = addHabitView.nameTextField.text, !name.isEmpty,
              let unit = addHabitView.unitTextField.text, !unit.isEmpty,
              let goalText = addHabitView.goalTextField.text, let goal = Int(goalText) else {
            return
        }
        
        let selectedFrequencyIdx = addHabitView.frequencySegmentedControl.selectedSegmentIndex
        let frequency = addHabitView.frequencySegmentedControl.titleForSegment(at: selectedFrequencyIdx)
        
        let pickerRow0 = addHabitView.picker.selectedRow(inComponent: 0)
        var pickerRow2 = 0
        if pickerData.count > 1 {
            // checking within bounds for days
            pickerRow2 = addHabitView.picker.selectedRow(inComponent: 2)
            guard pickerRow0 >= 0 && pickerRow0 < pickerData[0].count && pickerRow2 < pickerData[2].count else {
                AlertUtils.shared.showAlert(self, title: "Invalid deadline selected", message: "Please select a valid deadline")
                return
            }
        } else {
            // assuming pickerData is 1 column, checking within bounds for week and month
            guard pickerRow0 >= 0 && pickerRow0 < pickerData[0].count else {
                AlertUtils.shared.showAlert(self, title: "Invalid deadline selected", message: "Please select a valid deadline")
                return
            }
        }
        let pickerValue:String
        if frequency == FrequencyConstants.daily {
            pickerValue = String(format: "%02d:%02d", pickerData[0][pickerRow0], pickerData[2][pickerRow2])
        } else if frequency == FrequencyConstants.weekly {
            pickerValue = String(daysOfWeek[pickerRow0]!)
        } else {
            pickerValue = String(daysOfMonth[pickerRow0])
        }

        let categoryIDs = addHabitView.selectedCategories.map { $0.id! }
        
        let newHabit = HabitModel(
            name: name,
            categoryIDs: categoryIDs,
            streak: 0,
            goal: goal,
            unit: unit,
            frequency: frequency!,
            deadline: pickerValue,
            userUID: user.uid
        )

        do {
            try FirestoreService.shared.addHabit(habit: newHabit)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error adding habit: \(error.localizedDescription)")
        }
    }
}
