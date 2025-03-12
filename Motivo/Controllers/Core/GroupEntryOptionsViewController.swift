//
//  GroupViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

// This handles options screen for group matching (create new, join existing, join random)
class GroupEntryOptionsViewController: UIViewController, GroupEntryOptionsViewDelegate {

    private let groupView = GroupEntryOptionsView()
    
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
    
    func didTouchJoinExistingGroupButton() {
        let groupEntrySelectionVC = GroupEntrySelectionViewController(screenType: .joinExistingGroup)
        navigationController?.pushViewController(groupEntrySelectionVC, animated: true)
    }
    
    func didTouchJoinRandomGroupButton() {
        let groupEntrySelectionVC = GroupEntrySelectionViewController(screenType: .joinRandomGroup)
        navigationController?.pushViewController(groupEntrySelectionVC, animated: true)
    }
    
    func didTouchCreateGroupButton() {
        let groupEntrySelectionVC = GroupEntrySelectionViewController(screenType: .createNewGroup)
        navigationController?.pushViewController(groupEntrySelectionVC, animated: true)
    }
}
