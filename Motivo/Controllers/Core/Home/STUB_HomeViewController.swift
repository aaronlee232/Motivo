//
//  HomeViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

let dummyGroupMetadataList = [
    GroupMetadata(groupId: "000", image: UIImage(systemName: "person.3.fill")!, groupName: "Fitness 101", categories: ["Exercise", "Nutrition"], memberCount: 4, habitsCount: 3),
    GroupMetadata(groupId: "001", image: UIImage(systemName: "person.3.fill")!, groupName: "Bob's Warehouse", categories: ["Fitness", "Hobby"], memberCount: 10, habitsCount: 4),
    GroupMetadata(groupId: "002", image: UIImage(systemName: "person.3.fill")!, groupName: "Budget Fooding", categories: ["Finance", "Nutrition"], memberCount: 4, habitsCount: 20),
]

class HomeViewController: UIViewController, DefaultHomeViewDelegate {
    
    private var homeView:UIView?
    private let groupMetadataList =  dummyGroupMetadataList  // replace with firestore logic in homeManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHomepage()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
    }
    
    private func setupHomepage() {
        // TODO: set up logic for populating the homepage
        // right now, it just goes to the default homepage
        homeView = DefaultHomeView(groupList: dummyGroupMetadataList)
        view.addSubview(homeView!) // will have homeView initialized beforehand
        
        if let testView = homeView as? DefaultHomeView {
            homeView = testView
            testView.delegate = self
        }
        
        homeView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeView!.topAnchor.constraint(equalTo: view.topAnchor),
            homeView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didTouchAddGroupPlusButton() {
        let groupEntryVC = GroupEntryViewController()
        navigationController?.pushViewController(groupEntryVC, animated: true) // push show segue
    }
    
    func didTouchAddHabitsPlusButton() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    func didSelectGroupCell(groupIdx: Int) {
        let groupVC = GroupViewController(groupID: groupMetadataList[groupIdx].groupId)
        navigationController?.pushViewController(groupVC, animated: true)
    }
}
