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
    let titleLabel = BoldTitleLabel(textLabel: "Match with a Group")
    let subtitleLabel = SubtitleLabel(textLabel: "Start here with group matching")
    let createNewGroupButton = LabelIconButton(image: UIImage(systemName: "person.2.fill")!, title: "Create New")
    let joinRandomGroupButton = LabelIconButton(image: UIImage(systemName: "shuffle")!, title: "Join Random")
    let joinInviteGroupButton = LabelIconButton(image: UIImage(systemName: "person.fill.badge.plus")!, title: "Join Group")
    
    var delegate:GroupEntryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupUI() {
        
        subtitleLabel.changeFontSize(fontSize: 20)
        
        createNewGroupButton.addTarget(self, action: #selector(touchedCreateGroupButton), for: .touchUpInside)
        joinRandomGroupButton.addTarget(self, action: #selector(touchedJoinRandomGroupButton), for: .touchUpInside)
        joinInviteGroupButton.addTarget(self, action: #selector(touchedJoinInviteGroupButton), for: .touchUpInside)
        
        let topButtonsStackView = UIStackView(arrangedSubviews: [createNewGroupButton, joinRandomGroupButton])
        topButtonsStackView.axis = .horizontal
        topButtonsStackView.spacing = 15
        topButtonsStackView.distribution = .fillProportionally
        topButtonsStackView.alignment = .center
        
        let bottomButtonsStackView = UIStackView(arrangedSubviews: [joinInviteGroupButton])
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .fill
        bottomButtonsStackView.alignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [topButtonsStackView, bottomButtonsStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 15
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(mainStackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        createNewGroupButton.translatesAutoresizingMaskIntoConstraints = false
        joinRandomGroupButton.translatesAutoresizingMaskIntoConstraints = false
        joinInviteGroupButton.translatesAutoresizingMaskIntoConstraints = false
        topButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            topButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    @objc func touchedCreateGroupButton() {
        UIView.animate(withDuration: 0.2) {
            self.createNewGroupButton.backgroundColor = colorMainAccent.withAlphaComponent(0.2)
            self.createNewGroupButton.backgroundColor = .systemBackground
        }
        delegate?.didTouchCreateGroupButton()
    }
    
    @objc func touchedJoinRandomGroupButton() {
        UIView.animate(withDuration: 0.2) {
            self.joinRandomGroupButton.backgroundColor = colorMainAccent.withAlphaComponent(0.2)
            self.joinRandomGroupButton.backgroundColor = .systemBackground
        }
        delegate?.didTouchJoinRandomGroupButton()
    }
    
    @objc func touchedJoinInviteGroupButton() {
        UIView.animate(withDuration: 0.2) {
            self.joinInviteGroupButton.backgroundColor = colorMainAccent.withAlphaComponent(0.2)
            self.joinInviteGroupButton.backgroundColor = .systemBackground
        }
        delegate?.didTouchJoinInviteGroupButton()
    }
}
