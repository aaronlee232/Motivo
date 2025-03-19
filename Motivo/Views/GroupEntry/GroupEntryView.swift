//
//  GroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol GroupEntryViewDelegate:GroupEntryViewController {
    func didTouchJoinInviteGroupButton()
    func didTouchJoinRandomGroupButton()
    func didTouchCreateGroupButton()
}

class GroupEntryView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let createNewGroupButton = UIButton()
    let joinRandomGroupButton = UIButton()
    let joinInviteGroupButton = UIButton()
    
    var delegate:GroupEntryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.text = "Match with a Group"
        titleLabel.textColor = .systemBlue
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Join groups with these interests"
        
        createNewGroupButton.layer.borderColor = UIColor.black.cgColor
        createNewGroupButton.layer.borderWidth = 2
        createNewGroupButton.layer.cornerRadius = 8.0
        createNewGroupButton.setTitleColor(.systemBlue, for: .normal)
        createNewGroupButton.setTitle("Create New", for: .normal)
        
        joinRandomGroupButton.layer.borderColor = UIColor.black.cgColor
        joinRandomGroupButton.layer.borderWidth = 2
        joinRandomGroupButton.layer.cornerRadius = 8.0
        joinRandomGroupButton.setTitleColor(.systemBlue, for: .normal)
        joinRandomGroupButton.setTitle("Join Random", for: .normal)
        
        joinInviteGroupButton.layer.borderColor = UIColor.black.cgColor
        joinInviteGroupButton.layer.borderWidth = 2
        joinInviteGroupButton.layer.cornerRadius = 8.0
        joinInviteGroupButton.setTitleColor(.systemBlue, for: .normal)
        joinInviteGroupButton.setTitle("Join Group", for: .normal)
        
        createNewGroupButton.addTarget(self, action: #selector(touchedCreateGroupButton), for: .touchUpInside)
        joinRandomGroupButton.addTarget(self, action: #selector(touchedJoinRandomGroupButton), for: .touchUpInside)
        joinInviteGroupButton.addTarget(self, action: #selector(touchedJoinInviteGroupButton), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, createNewGroupButton, joinRandomGroupButton, joinInviteGroupButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            // stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50), // 50 pixels from top safe area
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }

    @objc func touchedCreateGroupButton() {
        delegate?.didTouchCreateGroupButton()
    }
    
    @objc func touchedJoinRandomGroupButton() {
        delegate?.didTouchJoinRandomGroupButton()
    }
    
    @objc func touchedJoinInviteGroupButton() {
        delegate?.didTouchJoinInviteGroupButton()
    }
}
