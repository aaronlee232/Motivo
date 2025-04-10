//
//  JoinInviteGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol JoinInviteGroupViewDelegate:JoinInviteGroupViewController {
    func didTouchJoinInviteGroupConfirmButton()
}

class JoinInviteGroupView: UIView {
    let titleLabel = BoldTitleLabel(textLabel: "Join a Group")
    let inviteCodeLabel = NormalLabel(textLabel: "Enter Group Invite Code")
    let inviteCodeTextField = GreyTextField(placeholderText: "Enter group invite code here", isSecure: false)
    let confirmButton = ActionButton(title: "CONFIRM")
    var delegate:JoinInviteGroupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inviteCodeLabel.textAlignment = .left
        inviteCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inviteCodeTextField.textAlignment = .left
        inviteCodeTextField.translatesAutoresizingMaskIntoConstraints = false

        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        let viewContainer = UIView()
        viewContainer.addSubview(titleLabel)
        viewContainer.addSubview(inviteCodeLabel)
        viewContainer.addSubview(inviteCodeTextField)
        viewContainer.addSubview(confirmButton)
        addSubview(viewContainer)
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Invite Code Label Constraints
            inviteCodeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            inviteCodeLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            inviteCodeLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Invite Code Text Field Constraints
            inviteCodeTextField.topAnchor.constraint(equalTo: inviteCodeLabel.bottomAnchor, constant: 20),
            inviteCodeTextField.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            inviteCodeTextField.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Confirm Button Constraints
            confirmButton.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleConfirmButton() {
        delegate?.didTouchJoinInviteGroupConfirmButton()
    }
}
