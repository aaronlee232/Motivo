//
//  HomeViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

let dummyGroupMetadataList = [
    GroupMetadata(groupId: "", image: UIImage(systemName: "person.3.fill")!, groupName: "Fitness 101", categories: ["Exercise", "Nutrition"], memberCount: 4, habitsCount: 3),
    GroupMetadata(groupId: "", image: UIImage(systemName: "person.3.fill")!, groupName: "Bob's Warehouse", categories: ["Fitness", "Hobby"], memberCount: 10, habitsCount: 4),
    GroupMetadata(groupId: "", image: UIImage(systemName: "person.3.fill")!, groupName: "Budget Fooding", categories: ["Finance", "Nutrition"], memberCount: 4, habitsCount: 20),
]

class HomeViewController: UIViewController, HomeViewDelegate {

    let dummyDataUtils = DummyDataUtils()
    private var homeView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHomepage()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
//        let addGroupButton = UIButton(type: .system)
//        addGroupButton.setTitle("Add Group", for: .normal)
//        addGroupButton.addTarget(self, action: #selector(openGroups), for: .touchUpInside)
//        
//        let populateConnectionsButton = UIButton(type: .system)
//        populateConnectionsButton.setTitle("(debug) Populate Connections", for: .normal)
//        populateConnectionsButton.addTarget(self, action: #selector(populateConnections), for: .touchUpInside)
        

//        view.addSubview(addGroupButton)
//        view.addSubview(populateConnectionsButton)
//        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
//        populateConnectionsButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            addGroupButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            addGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            populateConnectionsButton.topAnchor.constraint(equalTo: addGroupButton.bottomAnchor, constant: 30),
//            populateConnectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        ])
    }
    
//    @objc func openGroups() {
//        let groupRootVC = GroupEntryViewController()
//        navigationController?.pushViewController(groupRootVC, animated: true) // push show segue
//    }
    
    @objc func populateConnections () {
        dummyDataUtils.populateConnections()
    }
    
    private func setupHomepage() {
        // TODO: set up logic for populating the homepage
        // right now, it just goes to the default homepage
        homeView = HomeView(groupList: dummyGroupMetadataList)
        view.addSubview(homeView!) // will have homeView initialized beforehand
        
        if let testView = homeView as? HomeView {
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
        let groupRootVC = GroupEntryViewController()
        navigationController?.pushViewController(groupRootVC, animated: true) // push show segue
    }
    
    func didTouchAddHabitsPlusButton() {
        let groupRootVC = AddTaskViewController()
        navigationController?.pushViewController(groupRootVC, animated: true)
    }
}
