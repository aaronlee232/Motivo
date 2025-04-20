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
    private let statsManager = StatsManager()
    
    private var groupMetadataList: [GroupMetadata] = []
    
    var currentHomeViewStatus:HomeViewStatusOptions = .showDefault
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHomepage()
        loadUserStats()
        loadGroupMetadataList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserStats()
        loadGroupMetadataList()
        homeView.homeViewStatus = currentHomeViewStatus
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
    
    func loadUserStats() {
        Task {
            do {
                guard let userUID = AuthManager.shared.getCurrentUserAuthInstance()?.uid else {
                    fatalError("Error: No authenticated user.")
                }
                guard let username = try await statsManager.fetchCurrentUsername(forUserUID: userUID) else {
                    fatalError("Error: Failed to fetch user.")
                }
                self.homeView.username = username
                self.homeView.titleLabel.text = "Hi \(username)"
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Error loading in user stats.")
                print("Error loading in user stats: \(error.localizedDescription)")
            }
        }
    }
    
    func loadGroupMetadataList() {
        Task {
            do {
                // TODO: consolidate alert error messages for getCurrentUserAuthInstance
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                let habits = try await statsManager.fetchCurrentNumberOfHabits(forUserUID: user.uid)
                
                groupMetadataList = try await groupManager.fetchGroupMetadataList(forUserUID: user.uid)
                homeView.groupList = groupMetadataList
                if groupMetadataList.count > 0 && habits > 0 {
                    currentHomeViewStatus = .showData
                } else if groupMetadataList.count > 0 {
                    currentHomeViewStatus = .noHabits
                } else if habits > 0 {
                    currentHomeViewStatus = .noGroups
                } else {
                    currentHomeViewStatus = .showDefault
                }
                print("homeViewStatus: \(currentHomeViewStatus)")
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
