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
    var taskList: [DummyTask]
}

let dummyTableViewData = [
    CellData(opened: false, name: "Bob", profileImageURL: nil, taskList: dummyTaskList1.sorted { $0.taskStatus < $1.taskStatus }),
    CellData(opened: false, name: "Jane", profileImageURL: nil, taskList: dummyTaskList2.sorted { $0.taskStatus < $1.taskStatus })
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
        tableView.register(TaskProgressPreviewCell.self, forCellReuseIdentifier: TaskProgressPreviewCell.identifier)
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
            // Header cell + expanded task cells
            return tableViewData[section].taskList.count + 1
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
            cell.configureWith(name: sectionData.name, profileImageURL: sectionData.profileImageURL, taskList: sectionData.taskList)
            cell.updateExpandIcon(isExpanded: sectionData.opened)
            
            return cell
        } else {
            // Expanded task cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskProgressPreviewCell.identifier, for: indexPath) as? TaskProgressPreviewCell else {
                return UITableViewCell()
            }

            let sectionData = tableViewData[indexPath.section]
            let taskData = sectionData.taskList[indexPath.row - 1]
            cell.configureWith(taskStatus: taskData.taskStatus, taskName: taskData.name)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Open/Close a header cell's tasks
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
            // Placeholder for tap event on taskPreview cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
