//
//  JoinInviteGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol JoinInviteGroupViewDelegate:GroupEntryDetailViewController {
    func didTouchJoinInviteGroupConfirmButton()
}

class JoinInviteGroupView: UIView {
    let titleLabel = UILabel()
    let inviteCodeLabel = UILabel()
    let inviteCodeTextField = UITextField()
    let confirmButton = UIButton()
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
        titleLabel.text = "Join a Group"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inviteCodeLabel.textAlignment = .left
        inviteCodeLabel.text = "Enter Group Invite Code"
        inviteCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inviteCodeTextField.placeholder = "Enter group invite code here"
        inviteCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        confirmButton.layer.borderColor = UIColor.blue.cgColor
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.cornerRadius = 8.0
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
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
            titleLabel.topAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.topAnchor, constant: 50),
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
