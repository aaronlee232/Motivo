//
//  HomeViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class HomeViewController: UIViewController {

    let dummyDataUtils = DummyDataUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        let addGroupButton = UIButton(type: .system)
        addGroupButton.setTitle("Add Group", for: .normal)
        addGroupButton.addTarget(self, action: #selector(openGroups), for: .touchUpInside)
        
        let populateConnectionsButton = UIButton(type: .system)
        populateConnectionsButton.setTitle("(debug) Populate Connections", for: .normal)
        populateConnectionsButton.addTarget(self, action: #selector(populateConnections), for: .touchUpInside)
        

        view.addSubview(addGroupButton)
        view.addSubview(populateConnectionsButton)
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        populateConnectionsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            populateConnectionsButton.topAnchor.constraint(equalTo: addGroupButton.bottomAnchor, constant: 30),
            populateConnectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func openGroups() {
        let groupRootVC = GroupEntryViewController()
        navigationController?.pushViewController(groupRootVC, animated: true) // push show segue
    }
    
    @objc func populateConnections () {
        dummyDataUtils.populateConnections()
    }

}
