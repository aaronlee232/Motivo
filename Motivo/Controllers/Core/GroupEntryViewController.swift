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
        let groupEntryDetailVC = GroupEntryDetailViewController(screenType: .joinInviteGroup)
        navigationController?.pushViewController(groupEntryDetailVC, animated: true)
    }
    
    func didTouchJoinRandomGroupButton() {
        let groupEntryDetailVC = GroupEntryDetailViewController(screenType: .joinRandomGroup)
        navigationController?.pushViewController(groupEntryDetailVC, animated: true)
    }
    
    func didTouchCreateGroupButton() {
        let groupEntryDetailVC = GroupEntryDetailViewController(screenType: .createNewGroup)
        navigationController?.pushViewController(groupEntryDetailVC, animated: true)
    }
}
