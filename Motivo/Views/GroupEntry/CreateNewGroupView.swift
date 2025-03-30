//
//  CreateNewGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol CreateNewGroupViewDelegate:CreateNewGroupViewController {
    func didTouchCreateNewGroupConfirmButton()
}

class CreateNewGroupView: UIView {
    
    let titleLabel = BoldTitleLabel(textLabel: "New Group")
    let items = ["Public", "Private"]
    let visibilityLabel = NormalLabel(textLabel: "Visibility")
    var visibilitySegCtrl:UISegmentedControl
    let groupNameLabel = NormalLabel(textLabel: "Group Name")
    let groupNameTextField = GreyTextField(placeholderText: "Enter group name here", isSecure: false)
    let selectCategoriesLabel = NormalLabel(textLabel: "Select Group Categories")
    let categorySelectionView = CategorySelectionView()
    let confirmButton = ActionButton(title: "CONFIRM")
    
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
        
        
        self.visibilitySegCtrl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .valueChanged)
        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        visibilityLabel.translatesAutoresizingMaskIntoConstraints = false
        visibilitySegCtrl.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        groupNameTextField.translatesAutoresizingMaskIntoConstraints = false
        selectCategoriesLabel.translatesAutoresizingMaskIntoConstraints = false
        categorySelectionView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(visibilityLabel)
        addSubview(visibilitySegCtrl)
        addSubview(groupNameLabel)
        addSubview(groupNameTextField)
        addSubview(selectCategoriesLabel)
        addSubview(categorySelectionView)
        addSubview(confirmButton)
        
        // View Container Constraints
        NSLayoutConstraint.activate([
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Visibility Label Constraints
            visibilityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            visibilityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            visibilityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Visibility Segmented Control Constraints
            visibilitySegCtrl.topAnchor.constraint(equalTo: visibilityLabel.bottomAnchor, constant: 10),
            visibilitySegCtrl.leadingAnchor.constraint(equalTo: leadingAnchor),
            visibilitySegCtrl.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Group Name Label Constraints
            groupNameLabel.topAnchor.constraint(equalTo: visibilitySegCtrl.bottomAnchor, constant: 20),
            groupNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Group Name TextField Constraints
            groupNameTextField.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10),
            groupNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Select Group Categories Label Constraints
            selectCategoriesLabel.topAnchor.constraint(equalTo: groupNameTextField.bottomAnchor, constant: 20),
            selectCategoriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectCategoriesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Category Selection Constraints
            categorySelectionView.topAnchor.constraint(equalTo: selectCategoriesLabel.bottomAnchor, constant: 20),
            categorySelectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categorySelectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categorySelectionView.heightAnchor.constraint(equalToConstant: 250),

            // Confirm Button Constraints
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleConfirmButton() {
        delegate?.didTouchCreateNewGroupConfirmButton()
    }
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        selectedSegValue = sender.titleForSegment(at: selectedIndex)!
    }
}
