//
//  GroupTableView.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/7/25.
//

import UIKit

// AnyObject type because used in HomeView and ProfileView
protocol GroupTableViewDelegate:AnyObject {
    func didSelectGroupCell(groupIdx: Int)
}

class GroupTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    private var list:[GroupMetadata] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate:GroupTableViewDelegate?
    
    init(givenList: [GroupMetadata]) {
        super.init(frame: .zero)
        self.list = givenList
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        tableView.register(GroupCell.self, forCellReuseIdentifier: GroupCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableData(givenList: [GroupMetadata]) {
        list = givenList
    }
    
    @objc func handleDidSelectGroupCell(groupIdx: Int) {
        delegate?.didSelectGroupCell(groupIdx: groupIdx)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as? GroupCell else {
            return UITableViewCell()
        }

        let group = list[indexPath.section]
        cell.configureWith(groupID: group.groupID, image: group.image ?? UIImage(systemName: "person.3.fill")!, groupName: group.groupName, categories: group.categoryNames, memberCount: group.memberCount, habitsCount: group.habitsCount)
        return cell
    }

    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GroupCell.groupViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return GroupCell.groupViewDeadSpace // Adjust the space between sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  // 1 row per section
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectGroupCell(groupIdx: indexPath.section)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupUI() {
        tableView.separatorStyle = .singleLine
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
}
