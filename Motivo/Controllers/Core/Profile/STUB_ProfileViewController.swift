//
//  ProfileViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewDelegate, GroupTableViewDelegate {
    
    private var profileView = ProfileView()
    private let groupManager = GroupManager()
    private var groupMetadataList: [GroupMetadata] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupProfile()
        loadUserStats()
        loadGroupMetadataList()

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileView.settingsButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserStats()
        loadGroupMetadataList()
    }
    
    private func setupProfile() {
//        profileView = ProfileView(groupList: [])  // TODO: adjust approach to not use constructor and replace with real data
        view.addSubview(profileView)
        profileView.delegate = self
        profileView.groupTableView.delegate = self
        
//        if let testView = profileView as? ProfileView {
//            profileView = testView
//            testView.delegate = self
//        }
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    
    // Loading in username
    // TODO: might need to move code for calculating groups and days in here too
    func loadUserStats() {
        Task {
            do {
                guard let userUID = AuthManager.shared.getCurrentUserAuthInstance()?.uid else {
                    fatalError("Error: No authenticated user.")
                }
                guard let username = try await StatsManager.shared.fetchCurrentUsername(forUserUID: userUID) else {
                    fatalError("Error: Failed to fetch user.")
                }
                self.profileView.username.text = username
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Error loading in user stats.")
                print("Error loading in user stats: \(error.localizedDescription)")
            }
        }
    }
    
    // Using homepage function, organize later
    func loadGroupMetadataList() {
        Task {
            do {
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                
                groupMetadataList = try await groupManager.fetchGroupMetadataList(forUserUID: user.uid)
                profileView.groupList = groupMetadataList
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to retrieve user's group metadata list")
            }
        }
    }
    
    func didTouchSettingsButton() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func didSelectGroupCell(groupIdx: Int) {
        let groupVC = GroupViewController(groupID: groupMetadataList[groupIdx].groupID)
        navigationController?.pushViewController(groupVC, animated: true)
    }

}
