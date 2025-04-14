//
//  GroupOverviewView.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/1/25.
//

// View that you see when you click on a group on home page or profile page

import UIKit

class GroupOverviewView: UIView {
    
    // MARK: - UI Elements
    let groupCategoryLabel = UILabel()
    let categoryBadgesView = CategoryBadgesView()
    let memberHabitsLabel = UILabel()
    let tableView = UITableView()
    // TODO: Add heatmap calendar
    
    // MARK: - Properties
    var categories: [CategoryModel] = [] {
        didSet {
            categoryBadgesView.categories = categories
        }
    }
    var userHabitPairs: [(habit: HabitModel, user: UserModel)] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension GroupOverviewView {
    private func setupUI() {
        groupCategoryLabel.text = "Group Category"
        groupCategoryLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        memberHabitsLabel.text = "Group Member Habits"
        memberHabitsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tableView.register(HabitInfoCell.self, forCellReuseIdentifier: HabitInfoCell.identifier)

        addSubview(groupCategoryLabel)
        addSubview(categoryBadgesView)
        addSubview(memberHabitsLabel)
        addSubview(tableView)
        
        groupCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryBadgesView.translatesAutoresizingMaskIntoConstraints = false
        memberHabitsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            groupCategoryLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            groupCategoryLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            groupCategoryLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            categoryBadgesView.topAnchor.constraint(equalTo: groupCategoryLabel.bottomAnchor, constant: 12),
            categoryBadgesView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            categoryBadgesView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            categoryBadgesView.heightAnchor.constraint(equalToConstant: 100),
            
            memberHabitsLabel.topAnchor.constraint(equalTo: categoryBadgesView.bottomAnchor, constant: 12),
            memberHabitsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            memberHabitsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: memberHabitsLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableView Delegates
    extension GroupOverviewView: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return userHabitPairs.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitInfoCell.identifier, for: indexPath) as? HabitInfoCell else {
                return UITableViewCell()
            }
                    
            cell.configureWith(habit: userHabitPairs[indexPath.section].habit, user: userHabitPairs[indexPath.section].user)

            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            return footerView
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 8
        }
    }
