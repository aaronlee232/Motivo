//
//  CreateNewGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol CreateNewGroupViewDelegate:GroupEntrySelectionViewController {
    func didTouchCreateNewGroupConfirmButton()
}

class CreateNewGroupView: UIView {
    
    let titleLabel = UILabel()
    let items = ["Public", "Private"]
    let visibilityLabel = UILabel()
    var visibilitySegCtrl:UISegmentedControl
    let groupNameLabel = UILabel()
    let groupNameTextField = UITextField()
    let selectGroupCategoriesLabel = UILabel()
    let newGroupButton1 = UIButton()
    let newGroupButton2 = UIButton()
    let newGroupButton3 = UIButton()
    let newGroupButton4 = UIButton()
    let newGroupButton5 = UIButton()
    let newGroupButton6 = UIButton()
    let confirmButton = UIButton()
    var selectedGroupCategories:[String] = []
    var selectedSegValue:String
    var delegate:CreateNewGroupViewDelegate?
    
    override init(frame: CGRect) {
        self.visibilitySegCtrl = UISegmentedControl(items: items)
        self.visibilitySegCtrl.selectedSegmentIndex = 0
        self.selectedSegValue = self.visibilitySegCtrl.titleForSegment(at: 0)!
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.text = "New Group"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        visibilityLabel.textAlignment = .center
        visibilityLabel.text = "Visibility"
        visibilityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.visibilitySegCtrl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .valueChanged)
        visibilitySegCtrl.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.textAlignment = .center
        groupNameLabel.text = "Group Name"
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameTextField.placeholder = "Enter group name here"
        groupNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        selectGroupCategoriesLabel.text = "Select Group Categories"
        selectGroupCategoriesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        newGroupButton1.layer.borderColor = UIColor.black.cgColor
        newGroupButton1.layer.borderWidth = 2
        newGroupButton1.layer.cornerRadius = 8.0
        newGroupButton1.setTitleColor(.systemBlue, for: .normal)
        newGroupButton1.setTitle("Exercise", for: .normal)
        newGroupButton1.tag = 1
        newGroupButton1.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        newGroupButton2.layer.borderColor = UIColor.black.cgColor
        newGroupButton2.layer.borderWidth = 2
        newGroupButton2.layer.cornerRadius = 8.0
        newGroupButton2.setTitleColor(.systemBlue, for: .normal)
        newGroupButton2.setTitle("Nutrition", for: .normal)
        newGroupButton2.tag = 2
        newGroupButton2.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        newGroupButton3.layer.borderColor = UIColor.black.cgColor
        newGroupButton3.layer.borderWidth = 2
        newGroupButton3.layer.cornerRadius = 8.0
        newGroupButton3.setTitleColor(.systemBlue, for: .normal)
        newGroupButton3.setTitle("Productivity", for: .normal)
        newGroupButton3.tag = 3
        newGroupButton3.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        newGroupButton4.layer.borderColor = UIColor.black.cgColor
        newGroupButton4.layer.borderWidth = 2
        newGroupButton4.layer.cornerRadius = 8.0
        newGroupButton4.setTitleColor(.systemBlue, for: .normal)
        newGroupButton4.setTitle("Social", for: .normal)
        newGroupButton4.tag = 4
        newGroupButton4.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        newGroupButton5.layer.borderColor = UIColor.black.cgColor
        newGroupButton5.layer.borderWidth = 2
        newGroupButton5.layer.cornerRadius = 8.0
        newGroupButton5.setTitleColor(.systemBlue, for: .normal)
        newGroupButton5.setTitle("Finance", for: .normal)
        newGroupButton5.tag = 5
        newGroupButton5.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        newGroupButton6.layer.borderColor = UIColor.black.cgColor
        newGroupButton6.layer.borderWidth = 2
        newGroupButton6.layer.cornerRadius = 8.0
        newGroupButton6.setTitleColor(.systemBlue, for: .normal)
        newGroupButton6.setTitle("Hobbies", for: .normal)
        newGroupButton6.tag = 6
        newGroupButton6.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
        
        let buttonContainer = UIStackView(arrangedSubviews: [newGroupButton1, newGroupButton2, newGroupButton3, newGroupButton4, newGroupButton5, newGroupButton6])
        buttonContainer.axis = .vertical
        buttonContainer.spacing = 10
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        confirmButton.layer.borderColor = UIColor.blue.cgColor
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.cornerRadius = 8.0
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let viewContainer = UIView()
        viewContainer.addSubview(titleLabel)
        viewContainer.addSubview(visibilityLabel)
        viewContainer.addSubview(visibilitySegCtrl)
        viewContainer.addSubview(groupNameLabel)
        viewContainer.addSubview(groupNameTextField)
        viewContainer.addSubview(selectGroupCategoriesLabel)
        viewContainer.addSubview(buttonContainer)
        viewContainer.addSubview(confirmButton)
        addSubview(viewContainer)
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        // View Container Constraints
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Visibility Label Constraints
            visibilityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            visibilityLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            visibilityLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Visibility Segmented Control Constraints
            visibilitySegCtrl.topAnchor.constraint(equalTo: visibilityLabel.bottomAnchor, constant: 10),
            visibilitySegCtrl.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            visibilitySegCtrl.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Group Name Label Constraints
            groupNameLabel.topAnchor.constraint(equalTo: visibilitySegCtrl.bottomAnchor, constant: 20),
            groupNameLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            groupNameLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Group Name TextField Constraints
            groupNameTextField.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10),
            groupNameTextField.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            groupNameTextField.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Select Group Categories Label Constraints
            selectGroupCategoriesLabel.topAnchor.constraint(equalTo: groupNameTextField.bottomAnchor, constant: 20),
            selectGroupCategoriesLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            selectGroupCategoriesLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Button Container Constraints
            buttonContainer.topAnchor.constraint(equalTo: selectGroupCategoriesLabel.bottomAnchor, constant: 10),
            buttonContainer.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Confirm Button Constraints
            confirmButton.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: 10),
            confirmButton.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleButton(sender: UIButton) {
        var category:String
        switch sender.tag {
        case 1:
            category = "Exercise"
        case 2:
            category = "Nutrition"
        case 3:
            category = "Productivity"
        case 4:
            category = "Social"
        case 5:
            category = "Finance"
        case 6:
            category = "Hobbies"
        default:
            print("Failed at handling category assignment in handleButton > CreateNewGroupView.swift")
            return
        }
        
        if let index = selectedGroupCategories.firstIndex(of: category) {
            // deselect
            selectedGroupCategories.remove(at: index)
        } else {
            // select
            selectedGroupCategories.append(category)
        }
    }
    
    @objc func handleConfirmButton() {
        delegate?.didTouchCreateNewGroupConfirmButton()
    }
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        selectedSegValue = sender.titleForSegment(at: selectedIndex)!
    }
}
