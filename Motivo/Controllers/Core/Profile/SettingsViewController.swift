//
//  SettingsViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/8/25.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController, SettingsViewDelegate {
    
    private var settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSettings()
    }
    
    private func setupSettings() {
        view.addSubview(settingsView)
        settingsView.delegate = self
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didTouchThemesButton() {
        AlertUtils.shared.showAlert(self, title: "Themes", message: "Themes are currently unavailable :(")
    }
    
    func didTouchHelpButton() {
        AlertUtils.shared.showAlert(self, title: "Help", message: "Help? Help page is currently unavailable. You are on your own buddy")
    }
    
    func didTouchAboutButton() {
        AlertUtils.shared.showAlert(self, title: "About", message: "About page is currently unavailable :(")
    }
    
    func didTouchLogoutButton() {
        let controller = UIAlertController(
            title: "Log out of your account?",
            message: "",
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "LOG OUT", style: .destructive) {_ in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Sign out error")
            }
        })
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(controller, animated: true)
    }
}
