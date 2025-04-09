//
//  SettingsViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/8/25.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    private var settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSettings()
    }
    
    private func setupSettings() {
        view.addSubview(settingsView)
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
