//
//  RenameGroupView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/19/25.
//

import UIKit

protocol RenameGroupViewDelegate:RenameGroupViewController {
    func didTouchRenameGroupConfirmButton()
}

class RenameGroupView: UIView {
    
    // MARK: - UI Elements
    let titleLabel = BoldTitleLabel(textLabel: "Rename Group")
    let currentNameStack = UIStackView()
    let currentNamePromptLabel = NormalLabel(textLabel: "Current Group Name: ")
    let currentNameLabel = UILabel()  // TODO: Using UILabel due to lack of dynamic text support
    let spacerView = UIView()
    let newNamePromptLabel = UILabel()  // TODO: Using UILabel due to inflexible styling of NormalLabel
    let newNameTextField = GreyTextField(placeholderText: "Enter new group name here", isSecure: false)
    let confirmButton = ActionButton(title: "CONFIRM")
    
    // MARK: - Properties
    var delegate:RenameGroupViewDelegate?
    var group: GroupModel! {
        didSet {
            currentNameLabel.text = group.groupName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Allow spacerView to take up extra space so other elements are pushed to edges
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // TODO: Might need to refactor
        newNamePromptLabel.text = "New Group Name: "
        newNamePromptLabel.textColor = colorMainText
        newNamePromptLabel.font = UIFont(name: "Avenir-Light", size: 18)
        // TODO: Might need to refactor
        currentNameLabel.textColor = colorMainText
        currentNameLabel.font = UIFont(name: "Avenir-Light", size: 18)
        
        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        currentNameStack.translatesAutoresizingMaskIntoConstraints = false
        newNamePromptLabel.translatesAutoresizingMaskIntoConstraints = false
        newNameTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(currentNameStack)
        currentNameStack.addArrangedSubview(currentNamePromptLabel)
        currentNameStack.addArrangedSubview(currentNameLabel)
        currentNameStack.addArrangedSubview(spacerView)
        addSubview(newNamePromptLabel)
        addSubview(newNameTextField)
        addSubview(confirmButton)
        
        // View Container Constraints
        NSLayoutConstraint.activate([
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // current Name Constraints
            currentNameStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            currentNameStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentNameStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // New Name Prompt Label Constraints
            newNamePromptLabel.topAnchor.constraint(equalTo: currentNameStack.bottomAnchor, constant: 24),
            newNamePromptLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            newNamePromptLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // New Name Text Field Constraints
            newNameTextField.topAnchor.constraint(equalTo: newNamePromptLabel.bottomAnchor, constant: 24),
            newNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            newNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Confirm Button Constraints
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleConfirmButton() {
        delegate?.didTouchRenameGroupConfirmButton()
    }
}
