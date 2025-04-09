//
//  GroupProgress.swift
//  Motivo
//
//  Created by Aaron Lee on 4/2/25.
//

import UIKit

class GroupProgressView: UIView, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()

    var progressCells: [ProgressCell] = [] {
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
        tableView.register(UserProgressCell.self, forCellReuseIdentifier: UserProgressCell.identifier)
        tableView.register(HabitProgressPreviewCell.self, forCellReuseIdentifier: HabitProgressPreviewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return progressCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if progressCells[section].opened == true {
            // Header cell + expanded habit progress cells
            return progressCells[section].habitEntries.count + 1
        } else {
            // Header cell
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Header cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProgressCell.identifier, for: indexPath) as? UserProgressCell else {
                return UITableViewCell()
            }
            
            let sectionData = progressCells[indexPath.section]
            cell.configureWith(
                name: sectionData.name,
                profileImageURL: sectionData.profileImageURL,
                habitEntries: sectionData.habitEntries
            )
            cell.updateExpandIcon(isExpanded: sectionData.opened)
            
            return cell
        } else {
            // Expanded habit cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitProgressPreviewCell.identifier, for: indexPath) as? HabitProgressPreviewCell else {
                return UITableViewCell()
            }

            let sectionData = progressCells[indexPath.section]
            let habitEntry = sectionData.habitEntries[indexPath.row - 1]
            cell.configureWith(
                habitStatus: habitEntry.status,
                habitName: habitEntry.habit.name
            )
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Open/Close a header cell's habits
            if progressCells[indexPath.section].opened == true {
                progressCells[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                progressCells[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else {
            // Placeholder for tap event on habitPreview cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
