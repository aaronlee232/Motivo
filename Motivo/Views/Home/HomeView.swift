//
//  DefaultHomeView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/30/25.
//

import UIKit

protocol HomeViewDelegate:HomeViewController {
    func didTouchAddGroupPlusButton()
    func didTouchAddHabitPlusButton()
//    func didSelectGroupCell(groupIdx: Int)
}

class HomeView: UIView {
    let groupTableView = GroupTableView()
    private var tableView = UITableView()
    
    private let titleLabel = BoldTitleLabel(textLabel: "Hi User")
    private let myGroupsLabel = NormalLabel(textLabel: "My Groups")
    private let addGroupPlusButton = IconButton(image: UIImage(systemName: "plus")!)
    private let defaultMessageGroups = NormalLabel(textLabel: "No groups joined yet.")
    private let myHabitsLabel = NormalLabel(textLabel: "My Habits")
    private let addHabitsPlusButton = IconButton(image: UIImage(systemName: "plus")!)
    private let defaultMessageHabits = NormalLabel(textLabel: "No habits to track yet.")
    
    private var groupsStackView: UIStackView!
    private var habitsStackView: UIStackView!
    
    var delegate:HomeViewDelegate?
    var groupList:[GroupMetadata] = [] {
        didSet {
            groupTableView.updateTableData(givenList: groupList)
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        tableView.register(GroupCell.self, forCellReuseIdentifier: GroupCell.identifier)
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView = groupTableView.tableView
        Task {
            do {
                let username = try await FirestoreService.shared.fetchCurrentUsername()
                DispatchQueue.main.async {
                    self.titleLabel.text = "Hi \(username ?? "User")"
                }
            } catch {
                DispatchQueue.main.async {
                    print("Username Error: Failed to load username")
                }
            }
        }
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        titleLabel.textAlignment = .center
        
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
//        tableView.separatorStyle = .singleLine
////        tableView.separatorStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultMessageGroups.translatesAutoresizingMaskIntoConstraints = false
        defaultMessageHabits.translatesAutoresizingMaskIntoConstraints = false
        groupsStackView.translatesAutoresizingMaskIntoConstraints = false
        habitsStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(groupsStackView)
        addSubview(defaultMessageGroups)
        addSubview(habitsStackView)
        addSubview(defaultMessageHabits)
        addSubview(tableView)
        
        // TODO: for UI testing purposes only, need to implement checking if user already has groups
        var hasGroups = true
        if hasGroups {
            defaultMessageGroups.isHidden = true
            defaultMessageHabits.isHidden = true
        } else {
            tableView.isHidden = true
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            groupsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            groupsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            groupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            groupsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            habitsStackView.topAnchor.constraint(equalTo: defaultMessageGroups.bottomAnchor, constant: 200),
            habitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            habitsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: groupsStackView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: habitsStackView.topAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            tableView.topAnchor.constraint(equalTo: groupsStackView.bottomAnchor, constant: 10),
//            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            defaultMessageGroups.topAnchor.constraint(equalTo: groupsStackView.bottomAnchor, constant: 10),
            defaultMessageGroups.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            defaultMessageHabits.topAnchor.constraint(equalTo: habitsStackView.bottomAnchor, constant: 10),
            defaultMessageHabits.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
        ])
    }
    
    @objc func handleAddGroupPlusButton() {
        delegate?.didTouchAddGroupPlusButton()
    }
    
    @objc func handleAddHabitsPlusButton() {
        delegate?.didTouchAddHabitPlusButton()
    }
    
//    @objc func handleDidSelectGroupCell(groupIdx: Int) {
//        groupTableView.delegate?.didSelectGroupCell(groupIdx: groupIdx)
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        handleDidSelectGroupCell(groupIdx: indexPath.section)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as? GroupCell else { return UITableViewCell() }
////        let group = groupList[indexPath.row]
////        cell.configureWith(groupId: group.groupId, image: group.image, groupName: group.groupName, categories: group.categories, memberCount: group.memberCount, habitsCount: group.habitsCount)
////        return cell
//        
//        // Header cells
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as? GroupCell else {
//            return UITableViewCell()
//        }
//
//        let group = groupList[indexPath.section]
//        cell.configureWith(groupID: group.groupID, image: group.image ?? UIImage(systemName: "person.3.fill")!, groupName: group.groupName, categories: group.categoryNames, memberCount: group.memberCount, habitsCount: group.habitsCount)
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        handleDidSelectGroupCell(groupIdx: indexPath.section)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    // height for each cell
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return GroupCell.groupViewHeight + GroupCell.groupViewDeadSpace
//        return GroupCell.groupViewHeight
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return GroupCell.groupViewDeadSpace // Adjust the space between sections
//    }
    
    // Set header height to create spacing
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0 : GroupCell.groupViewDeadSpace // no top spacing before the first section
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let spacer = UIView()
//        spacer.backgroundColor = .systemRed
//        print("making header for section: \(section)")
//        return spacer
//    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return groupList.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1  // 1 row per section
//    }
}
