//
//  ProfileViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
    private var profileView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfile()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
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
    
    private func setupProfile() {
        profileView = ProfileView(groupList: [])  // TODO: adjust approach to not use constructor and replace with real data
        view.addSubview(profileView!)
        
        if let testView = profileView as? ProfileView {
            profileView = testView
            testView.delegate = self
        }
        
        profileView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView!.topAnchor.constraint(equalTo: view.topAnchor),
            profileView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
}
