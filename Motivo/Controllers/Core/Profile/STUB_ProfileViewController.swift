//
//  ProfileViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, ProfileViewDelegate, GroupTableViewDelegate {
    
    private var profileView = ProfileView()
    private let groupManager = GroupManager()
    private var groupMetadataList: [GroupMetadata] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupProfile()
        loadGroupMetadataList()
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGroupMetadataList()
    }
    
    private func setupProfile() {
//        profileView = ProfileView(groupList: [])  // TODO: adjust approach to not use constructor and replace with real data
        view.addSubview(profileView)
        
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
    
    func didSelectGroupCell(groupIdx: Int) {
        let groupVC = GroupViewController(groupID: groupMetadataList[groupIdx].groupID)
        navigationController?.pushViewController(groupVC, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
}
