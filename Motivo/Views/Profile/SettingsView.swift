//
//  SettingsView.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/8/25.
//

import UIKit

let settingsList = ["Themes", "Help", "About", "Logout"]

protocol SettingsViewDelegate:SettingsViewController {
    func didTouchThemesButton()
    func didTouchHelpButton()
    func didTouchAboutButton()
    func didTouchLogoutButton()
}

class SettingsView: UIView, UITableViewDelegate, UITableViewDataSource {

    private let titleLabel = BoldTitleLabel(textLabel: "Settings")
    private var tableView = UITableView()
    private let cellIdentifier = "SettingsCell"
    
    var delegate:SettingsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = settingsList[indexPath.row]
        cell.textLabel?.textColor = colorMainText
        // use UIListContentConfiguration() for adding images
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = indexPath.row
        switch option {
        case 0:
            handleThemesButton()
        case 1:
            handleHelpButton()
        case 2:
            handleAboutButton()
        case 3:
            handleLogoutButton()
        default:
            print("accessed unknown cell")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc func handleThemesButton() {
        delegate?.didTouchThemesButton()
    }
    
    @objc func handleHelpButton() {
        delegate?.didTouchHelpButton()
    }
    
    @objc func handleAboutButton() {
        delegate?.didTouchAboutButton()
    }
    
    @objc func handleLogoutButton() {
        delegate?.didTouchLogoutButton()
    }
}
