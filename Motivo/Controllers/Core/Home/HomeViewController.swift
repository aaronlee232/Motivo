//
//  HomeViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class HomeViewController: UIViewController, HomeViewDelegate, GroupTableViewDelegate {

    private var homeView = HomeView()
    private let homeManger = HomeManager()
    
    private var groupMetadataList: [GroupMetadata] = []
    
    var currentHomeViewStatus:HomeViewStatusOptions = .showDefault
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomepage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUser()
        loadGroupMetadataList()
        homeView.homeViewStatus = currentHomeViewStatus
    }
    
    private func setupHomepage() {
        view.backgroundColor = .systemBackground
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
    
    func loadUser() {
        Task {
            do {
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                
                let username = try await homeManger.fetchCurrentUsername(forUserUID: user.uid)
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
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                
                groupMetadataList = try await homeManger.fetchGroupMetadataList(forUserUID: user.uid)
                homeView.configure(withGroupMetadataList: groupMetadataList)
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
