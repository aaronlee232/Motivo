//
//  RenameGroupViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 4/19/25.
//

import UIKit

class RenameGroupViewController: UIViewController {
    
    let renameGroupView = RenameGroupView()
    
    let groupManager = GroupManager()
    var groupID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroup()
        setupUI()
        renameGroupView.delegate = self
    }
}

// MARK: UI Setup
extension RenameGroupViewController {
    func setupUI() {
        view.addSubview(renameGroupView)
        renameGroupView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            renameGroupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            renameGroupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            renameGroupView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            renameGroupView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Data Fetching
extension RenameGroupViewController {
    func loadGroup() {
        Task {
            guard let group = try await groupManager.fetchGroup(groupID: groupID) else {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Group does not exist")
                navigationController?.popViewController(animated: true)
                return
            }
            
            renameGroupView.group = group
        }
    }
}

// MARK: - Rename Group View Delegate
extension RenameGroupViewController: RenameGroupViewDelegate {
    func didTouchRenameGroupConfirmButton() {
        Task {
            do {
                guard let newGroupName = renameGroupView.newNameTextField.text else {
                    AlertUtils.shared.showAlert(self, title: "Invalid Name", message: "Group name cannot be empty")
                    return
                }
                
                try await groupManager.updateGroupName(ofGroupWithID: groupID, withName: newGroupName)
                navigationController?.popViewController(animated: true)
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to change group name")
            }
        }
    }
}
