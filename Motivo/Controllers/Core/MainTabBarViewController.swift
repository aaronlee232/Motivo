//
//  ViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/3/25.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
        
        // Configure Tab Navigation for core view controllers
        let taskVC = UINavigationController(rootViewController: TaskViewController())
        let chatVC = UINavigationController(rootViewController: ChatViewController())
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let peopleVC = UINavigationController(rootViewController: PeopleViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        // Set icons for navigation items (using SF Symbols)
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        taskVC.tabBarItem.image = UIImage(systemName: "checklist.checked")
        chatVC.tabBarItem.image = UIImage(systemName: "message")
        peopleVC.tabBarItem.image = UIImage(systemName: "person.3")
        profileVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        // Set titles for VC
        homeVC.title = "Overview"
        taskVC.title = "My Habits"
        chatVC.title = "Chats"
        peopleVC.title = "Connections"
        profileVC.title = "My Profile"
        
        setViewControllers([taskVC, chatVC, homeVC, peopleVC, profileVC], animated: true)
    }


}

