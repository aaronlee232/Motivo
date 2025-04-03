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
//    func didSelectGroupCell()
}

class DefaultHomeView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var groupList:[GroupMetadata]!
    private var tableView = UITableView()
    
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
    
    init(groupList:[GroupMetadata]) {
        self.groupList = groupList
        super.init(frame: .zero)
        tableView.register(GroupCell.self, forCellReuseIdentifier: GroupCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
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
        
//        tableView.rowHeight = UITableView.automaticDimension;
//        tableView.estimatedRowHeight = GroupCell.groupViewHeight + 40;
        tableView.separatorStyle = .singleLine
//        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        myGroupsLabel.translatesAutoresizingMaskIntoConstraints = false
//        addGroupPlusButton.translatesAutoresizingMaskIntoConstraints = false
        defaultMessageGroups.translatesAutoresizingMaskIntoConstraints = false
//        myHabitsLabel.translatesAutoresizingMaskIntoConstraints = false
//        addHabitsPlusButton.translatesAutoresizingMaskIntoConstraints = false
        defaultMessageHabits.translatesAutoresizingMaskIntoConstraints = false
        groupsStackView.translatesAutoresizingMaskIntoConstraints = false
        habitsStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(titleLabel)
//        addSubview(groupsStackView)
//        addSubview(defaultMessageGroups)
//        addSubview(habitsStackView)
//        addSubview(defaultMessageHabits)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            groupsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            groupsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            groupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            groupsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            defaultMessageGroups.topAnchor.constraint(equalTo: groupsStackView.bottomAnchor, constant: 10),
//            defaultMessageGroups.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
//            habitsStackView.topAnchor.constraint(equalTo: defaultMessageGroups.bottomAnchor, constant: 100),
//            habitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            habitsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            defaultMessageHabits.topAnchor.constraint(equalTo: habitsStackView.bottomAnchor, constant: 10),
//            defaultMessageHabits.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
//        ])
    }
    
    @objc func handleAddGroupPlusButton() {
        delegate?.didTouchAddGroupPlusButton()
    }
    
    @objc func handleAddHabitsPlusButton() {
        delegate?.didTouchAddHabitsPlusButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as? GroupCell else { return UITableViewCell() }
        let group = groupList[indexPath.row]
        cell.configureWith(groupId: group.groupId, image: group.image, groupName: group.groupName, categories: group.categories, memberCount: group.memberCount, habitsCount: group.habitsCount)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Group: \(groupList[indexPath.row].groupName)")
//        print(groupList[indexPath.row].categories)
//        print("Members: \(groupList[indexPath.row].memberCount)")
//        print("Habits: \(groupList[indexPath.row].habitsCount)")
//        tableView.deselectRow(at: indexPath, animated: false)
//    }

    
    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GroupCell.groupViewHeight + GroupCell.groupViewDeadSpace
    }
}
