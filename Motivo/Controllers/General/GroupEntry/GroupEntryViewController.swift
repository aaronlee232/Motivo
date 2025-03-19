//
//  GroupViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

// This handles options screen for group matching (create new, join invite, join random)
class GroupEntryViewController: UIViewController, GroupEntryViewDelegate {

    private let groupView = GroupEntryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(groupView)
        setupConstraints()
        groupView.delegate = self
    }
    
    private func setupConstraints() {
        groupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupView.topAnchor.constraint(equalTo: view.topAnchor),
            groupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            groupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            groupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didTouchJoinInviteGroupButton() {
        let joinInviteGroupVC = JoinInviteGroupViewController()
        navigationController?.pushViewController(joinInviteGroupVC, animated: true)
    }
    
    func didTouchJoinRandomGroupButton() {
        let joinRandomGroupVC = JoinRandomGroupViewController()
        navigationController?.pushViewController(joinRandomGroupVC, animated: true)
    }
    
    func didTouchCreateGroupButton() {
        let createNewGroupVC = CreateNewGroupViewController()
        navigationController?.pushViewController(createNewGroupVC, animated: true)
    }
}
