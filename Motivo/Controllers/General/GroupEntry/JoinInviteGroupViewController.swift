//
//  GroupEntryInviteJoinViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import UIKit

class JoinInviteGroupViewController: UIViewController, JoinInviteGroupViewDelegate {
    let groupEntryManager = GroupEntryManager()
    private let joinInviteGroupView = JoinInviteGroupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(joinInviteGroupView)
        setupConstraints()
        
        joinInviteGroupView.delegate = self
    }
    
    private func setupConstraints() {
        joinInviteGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinInviteGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            joinInviteGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            joinInviteGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            joinInviteGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didTouchJoinInviteGroupConfirmButton() {
        // group invite code = groupID
        Task {
            guard let groupID = joinInviteGroupView.inviteCodeTextField.text, !joinInviteGroupView.inviteCodeTextField.text!.isEmpty else {
                AlertUtils.shared.showAlert(self, title: "Empty group invite code", message: "Please enter a valid group invite code")
                return
            }
            do {
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "User not valid", message: "User not logged in")
                    return
                }
                guard let verifiedGroup = try await groupEntryManager.fetchGroup(groupID: groupID) else {
                    AlertUtils.shared.showAlert(self, title: "Invalid group invite code", message: "Please enter a valid group invite code")
                    return
                }
                guard try await !groupEntryManager.isUserMemberOfGroup(with: verifiedGroup.id!, uid: userAuthInstance.uid) else {
                    AlertUtils.shared.showAlert(self, title: "Already in group", message: "Please enter a different group invite code")
                    return
                }
                let groupMembership = GroupMembershipModel(groupID: verifiedGroup.id!, userUID: userAuthInstance.uid)
                try groupEntryManager.insertGroupMembership(membership: groupMembership)
                
                joinInviteGroupView.inviteCodeTextField.text = nil
                
                // Pop to HomeVC, then push GroupVC
                if let navController = navigationController,
                   let homeVC = navController.viewControllers.first(where: { $0 is HomeViewController }) {
                    
                    let groupVC = GroupViewController(groupID: groupID)
                    navController.setViewControllers([homeVC, groupVC], animated: true)
                }
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to join group specified")
            }
        }
    }
}
