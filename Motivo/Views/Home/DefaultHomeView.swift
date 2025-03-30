//
//  DefaultHomeView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/30/25.
//

import UIKit

protocol DefaultHomeViewDelegate:HomeViewController {
    func didTouchAddGroupPlusButton()
    func didTouchAddHabitsPlusButton()
}

class DefaultHomeView: UIView {
    
    private let titleLabel = BoldTitleLabel(textLabel: "Hi User") // TODO: replace with username
    private let myGroupsLabel = NormalLabel(textLabel: "My Groups")
    private let addGroupPlusButton = IconButton(image: UIImage(systemName: "plus")!)
    private let defaultMessageGroups = NormalLabel(textLabel: "No groups joined yet.")
    private let myHabitsLabel = NormalLabel(textLabel: "My Habits")
    private let addHabitsPlusButton = IconButton(image: UIImage(systemName: "plus")!)
    private let defaultMessageHabits = NormalLabel(textLabel: "No habits to track yet.")
    
    private var groupsStackView: UIStackView!
    private var habitsStackView: UIStackView!
    
    var delegate:DefaultHomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        myGroupsLabel.setBoldText(status: true)
        myHabitsLabel.setBoldText(status: true)
        
        addGroupPlusButton.addTarget(self, action: #selector(handleAddGroupPlusButton), for: .touchUpInside)
        addHabitsPlusButton.addTarget(self, action: #selector(handleAddHabitsPlusButton), for: .touchUpInside)
        
        groupsStackView = UIStackView(arrangedSubviews: [myGroupsLabel, addGroupPlusButton])
        groupsStackView.axis = .horizontal
        groupsStackView.alignment = .center
        groupsStackView.spacing = 0
        groupsStackView.distribution = .equalSpacing // since 2 elements, elements will be at the ends of the stack view
        
        habitsStackView = UIStackView(arrangedSubviews: [myHabitsLabel, addHabitsPlusButton])
        habitsStackView.axis = .horizontal
        habitsStackView.alignment = .center
        habitsStackView.spacing = 0
        habitsStackView.distribution = .equalSpacing
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        myGroupsLabel.translatesAutoresizingMaskIntoConstraints = false
        addGroupPlusButton.translatesAutoresizingMaskIntoConstraints = false
        defaultMessageGroups.translatesAutoresizingMaskIntoConstraints = false
        myHabitsLabel.translatesAutoresizingMaskIntoConstraints = false
        addHabitsPlusButton.translatesAutoresizingMaskIntoConstraints = false
        defaultMessageHabits.translatesAutoresizingMaskIntoConstraints = false
        groupsStackView.translatesAutoresizingMaskIntoConstraints = false
        habitsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(groupsStackView)
        addSubview(defaultMessageGroups)
        addSubview(habitsStackView)
        addSubview(defaultMessageHabits)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            groupsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            groupsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            groupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            groupsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            defaultMessageGroups.topAnchor.constraint(equalTo: groupsStackView.bottomAnchor, constant: 10),
            defaultMessageGroups.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            habitsStackView.topAnchor.constraint(equalTo: defaultMessageGroups.bottomAnchor, constant: 100),
            habitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            habitsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            defaultMessageHabits.topAnchor.constraint(equalTo: habitsStackView.bottomAnchor, constant: 10),
            defaultMessageHabits.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
        ])
    }
    
    @objc func handleAddGroupPlusButton() {
        delegate?.didTouchAddGroupPlusButton()
    }
    
    @objc func handleAddHabitsPlusButton() {
        delegate?.didTouchAddHabitsPlusButton()
    }
}
