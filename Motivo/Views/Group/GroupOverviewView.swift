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
    // Heatmap
    // TODO: Add heatmap calendar
    
    // group categories
    let groupCategoryLabel = UILabel()
    let categoryBadgesView = CategoryBadgesView()
    
    // group member tasks that have the same categories as group
    let memberHabitsLabel = UILabel()
    let tableView = UITableView()  // TODO: Implement delegate functions and use/create new habit cell
    
    // MARK: - Properties
    var categories: [CategoryModel] = [] {
        didSet {
            categoryBadgesView.categories = categories
        }
    }
    var habits: [HabitModel] = [] {
        didSet {
            tableView.reloadData()
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
        groupCategoryLabel.text = "Group Category"

        addSubview(groupCategoryLabel)
        addSubview(categoryBadgesView)
        
        groupCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryBadgesView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            groupCategoryLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            groupCategoryLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            groupCategoryLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            categoryBadgesView.topAnchor.constraint(equalTo: groupCategoryLabel.bottomAnchor),
            categoryBadgesView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            categoryBadgesView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            categoryBadgesView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
