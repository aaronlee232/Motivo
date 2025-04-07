//
//  HomeViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class HomeViewController: UIViewController, HomeViewDelegate, GroupTableViewDelegate {

    private var homeView = HomeView()
    private let groupManager = GroupManager()
    
    private var groupMetadataList: [GroupMetadata] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHomepage()
        loadGroupMetadataList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGroupMetadataList()
    }
    
    private func setupHomepage() {
        view.addSubview(homeView)
        homeView.delegate = self
        homeView.groupTableView.delegate = self
    
        homeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadGroupMetadataList() {
        Task {
            do {
                // TODO: consolidate alert error messages for getCurrentUserAuthInstance
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                
                groupMetadataList = try await groupManager.fetchGroupMetadataList(forUserUID: user.uid)
                homeView.groupList = groupMetadataList
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to retrieve user's group metadata list")
            }
        }
    }

    func didTouchAddGroupPlusButton() {
        let groupEntryVC = GroupEntryViewController()
        navigationController?.pushViewController(groupEntryVC, animated: true) // push show segue
    }
    
    func didTouchAddHabitPlusButton() {
        let addHabitVC = AddHabitViewController()
        navigationController?.pushViewController(addHabitVC, animated: true)
    }
    
    func didSelectGroupCell(groupIdx: Int) {
        let groupVC = GroupViewController(groupID: groupMetadataList[groupIdx].groupID)
        navigationController?.pushViewController(groupVC, animated: true)
    }
}
