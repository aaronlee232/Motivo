//
//  HomeViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        let addGroupButton = UIButton(type: .system)
        addGroupButton.setTitle("+", for: .normal)
        addGroupButton.addTarget(self, action: #selector(openGroups), for: .touchUpInside)
        view.addSubview(addGroupButton)
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addGroupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func openGroups() {
        let groupRootVC = GroupEntryOptionsViewController()
        navigationController?.pushViewController(groupRootVC, animated: true) // push show segue
    }
}
