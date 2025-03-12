//
//  GroupEntrySelectionViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

enum GroupEntrySelectionType {
    case createNewGroup
    case joinExistingGroup
    case joinRandomGroup
}

// This handles the screens for create new, join existing, and join random groups
class GroupEntrySelectionViewController: UIViewController, GroupEntrySelectionViewDelegate {
    
    private let createNewGroupView = CreateNewGroupView()
    private let joinExistingGroupView = JoinExistingGroupView()
    private let joinRandomGroupView = JoinRandomGroupView()
    let groupMatchingManager = GroupMatchingManager()
    var screenType: GroupEntrySelectionType
    
    init(screenType: GroupEntrySelectionType) {
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
        view.addSubview(joinExistingGroupView)
        view.addSubview(joinRandomGroupView)
        setupConstraints()
        configureScreen()
        createNewGroupView.delegate = self
        // TODO: other delegates
    }
    
    private func setupConstraints() {
        createNewGroupView.translatesAutoresizingMaskIntoConstraints = false
        joinExistingGroupView.translatesAutoresizingMaskIntoConstraints = false
        joinRandomGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createNewGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            createNewGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createNewGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createNewGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            joinExistingGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            joinExistingGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            joinExistingGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            joinExistingGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            joinExistingGroupView.isHidden = true
            joinRandomGroupView.isHidden = true
        case .joinExistingGroup:
            createNewGroupView.isHidden = true
            joinExistingGroupView.isHidden = false
            joinRandomGroupView.isHidden = true
        case .joinRandomGroup:
            createNewGroupView.isHidden = true
            joinExistingGroupView.isHidden = true
            joinRandomGroupView.isHidden = false
        }
    }
    
    func didTouchCreateNewGroupConfirmButton() {
        guard let groupName = createNewGroupView.groupNameTextField.text else {
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
                print("groupID: \(groupID)")
                let groupMembership = GroupMembershipModel(groupId: groupID, userUid: userAuthInstance.uid)
                try await groupMatchingManager.insertGroupMembership(membership: groupMembership)
                AlertUtils.shared.showAlert(self, title: "Debug: Group \(groupName) Created", message: "This is a debug message")
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to create a new group.")
            }
        }
    }
}
