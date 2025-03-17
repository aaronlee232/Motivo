//
//  GroupEntryDetailViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

enum GroupEntryDetailScreenType {
    case createNewGroup
    case joinInviteGroup
    case joinRandomGroup
}

// This handles the screens for create new, join invite, and join random groups
class GroupEntryDetailViewController: UIViewController, CreateNewGroupViewDelegate, JoinInviteGroupViewDelegate, JoinRandomGroupViewDelegate {
    
    private let createNewGroupView = CreateNewGroupView()
    private let joinInviteGroupView = JoinInviteGroupView()
    private let joinRandomGroupView = JoinRandomGroupView()
    let groupMatchingManager = GroupMatchingManager()
    var screenType: GroupEntryDetailScreenType
    
    init(screenType: GroupEntryDetailScreenType) {
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(createNewGroupView)
        view.addSubview(joinInviteGroupView)
        view.addSubview(joinRandomGroupView)
        setupConstraints()
        configureScreen()
        createNewGroupView.delegate = self
        joinInviteGroupView.delegate = self
        joinRandomGroupView.delegate = self
    }
    
    private func setupConstraints() {
        createNewGroupView.translatesAutoresizingMaskIntoConstraints = false
        joinInviteGroupView.translatesAutoresizingMaskIntoConstraints = false
        joinRandomGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createNewGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            createNewGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createNewGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createNewGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            joinInviteGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            joinInviteGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            joinInviteGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            joinInviteGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            joinRandomGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            joinRandomGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            joinRandomGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            joinRandomGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureScreen() {
        // show screen depending on type
        switch screenType {
        case .createNewGroup:
            createNewGroupView.isHidden = false
            joinInviteGroupView.isHidden = true
            joinRandomGroupView.isHidden = true
        case .joinInviteGroup:
            createNewGroupView.isHidden = true
            joinInviteGroupView.isHidden = false
            joinRandomGroupView.isHidden = true
        case .joinRandomGroup:
            createNewGroupView.isHidden = true
            joinInviteGroupView.isHidden = true
            joinRandomGroupView.isHidden = false
        }
    }
    
    func didTouchCreateNewGroupConfirmButton() {
        guard let groupName = createNewGroupView.groupNameTextField.text,
              !createNewGroupView.groupNameTextField.text!.isEmpty else {
            AlertUtils.shared.showAlert(self, title: "No group name", message: "Enter a group name in the text field above")
            return
        }
        guard !createNewGroupView.selectedGroupCategories.isEmpty else {
            AlertUtils.shared.showAlert(self, title: "No group categories selected", message: "Select at least 1 group category")
            return
        }
        Task {
            do {
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "User not valid", message: "User not logged in")
                    return
                }
                
                let group = GroupModel(groupName: groupName, groupCategories: createNewGroupView.selectedGroupCategories, creator: userAuthInstance.uid)
                
                // adds to firestore for both group and group membership async
                let groupID = try await groupMatchingManager.insertGroupDataAsync(group: group)
                let groupMembership = GroupMembershipModel(groupId: groupID, userUid: userAuthInstance.uid)
                try await groupMatchingManager.insertGroupMembership(membership: groupMembership)
                AlertUtils.shared.showAlert(self, title: "Debug: Group \(groupName) Created", message: "This is a debug message")
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to create a new group.")
            }
        }
    }
    
    func didTouchJoinInviteGroupConfirmButton() {
        // group invite code = groupID
        Task {
            guard let groupId = joinInviteGroupView.inviteCodeTextField.text, !joinInviteGroupView.inviteCodeTextField.text!.isEmpty else {
                AlertUtils.shared.showAlert(self, title: "Empty group invite code", message: "Please enter a valid group invite code")
                return
            }
            do {
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "User not valid", message: "User not logged in")
                    return
                }
                guard let verifiedGroup = try await groupMatchingManager.fetchGroup(groupId: groupId) else {
                    AlertUtils.shared.showAlert(self, title: "Invalid group invite code", message: "Please enter a valid group invite code")
                    return
                }
                guard try await !groupMatchingManager.isMemberOfGroup(with: verifiedGroup.id!, uid: userAuthInstance.uid) else {
                    AlertUtils.shared.showAlert(self, title: "Already in group", message: "Please enter a different group invite code")
                    return
                }
                let groupMembership = GroupMembershipModel(groupId: verifiedGroup.id!, userUid: userAuthInstance.uid)
                try await groupMatchingManager.insertGroupMembership(membership: groupMembership)
                AlertUtils.shared.showAlert(self, title: "Debug: Group Membership created", message: "This is a debug message")
                joinInviteGroupView.inviteCodeTextField.text = nil
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to join group specified")
            }
        }
    }
    
    func didTouchJoinRandomGroupConfirmButton() {
        return
    }
}
