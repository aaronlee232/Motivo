//
//  CreateNewGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

class CreateNewGroupView: UIView {
    
    let titleLabel = UILabel()
    let items = ["Public", "Private"]
    let visibilityLabel = UILabel()
    var visibilitySegCtrl:UISegmentedControl
    let groupNameLabel = UILabel()
    let groupNameTextField = UITextField()
    let selectGroupCategoriesLabel = UILabel()
    // let selectGroupCategories TODO: custom class
    let confirmButton = UIButton()
    
    override init(frame: CGRect) {
        self.visibilitySegCtrl = UISegmentedControl(items: items)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.text = "New Group"
        
        visibilityLabel.textAlignment = .center
        visibilityLabel.text = "Visibility"
        
        groupNameLabel.textAlignment = .center
        groupNameLabel.text = "Group Name"
        
        groupNameTextField.placeholder = "Enter group name here"
        
        selectGroupCategoriesLabel.text = "Select Group Categories"
        
        confirmButton.setTitle("CONFIRM", for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, visibilityLabel, visibilitySegCtrl, groupNameLabel, groupNameTextField, selectGroupCategoriesLabel, confirmButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}
