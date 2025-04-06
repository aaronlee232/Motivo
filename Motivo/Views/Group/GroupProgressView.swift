//
//  GroupProgress.swift
//  Motivo
//
//  Created by Aaron Lee on 4/2/25.
//

import UIKit

struct CellData {
    var opened = Bool()
    var name: String
    var profileImageURL: String?
    var habitList: [DummyHabit]
}

let dummyTableViewData = [
    CellData(opened: false, name: "Bob", profileImageURL: nil, habitList: dummyHabitList1.sorted { $0.habitStatus < $1.habitStatus }),
    CellData(opened: false, name: "Jane", profileImageURL: nil, habitList: dummyHabitList2.sorted { $0.habitStatus < $1.habitStatus })
]

class GroupProgressView: UIView, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()

    var tableViewData: [CellData] = dummyTableViewData

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        tableView.register(UserProgressOverviewCell.self, forCellReuseIdentifier: UserProgressOverviewCell.identifier)
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
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            // Header cell + expanded habit progress cells
            return tableViewData[section].habitList.count + 1
        } else {
            // Header cell
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Header cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProgressOverviewCell.identifier, for: indexPath) as? UserProgressOverviewCell else {
                return UITableViewCell()
            }
            
            let sectionData = tableViewData[indexPath.section]
            cell.configureWith(name: sectionData.name, profileImageURL: sectionData.profileImageURL, habitList: sectionData.habitList)
            cell.updateExpandIcon(isExpanded: sectionData.opened)
            
            return cell
        } else {
            // Expanded habit cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitProgressPreviewCell.identifier, for: indexPath) as? HabitProgressPreviewCell else {
                return UITableViewCell()
            }

            let sectionData = tableViewData[indexPath.section]
            let habitData = sectionData.habitList[indexPath.row - 1]
            cell.configureWith(habitStatus: habitData.habitStatus, habitName: habitData.name)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Open/Close a header cell's habits
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
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
