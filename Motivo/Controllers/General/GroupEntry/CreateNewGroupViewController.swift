//
//  GroupEntryCreateViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import UIKit

class CreateNewGroupViewController: UIViewController, CreateNewGroupViewDelegate, CategorySelectionViewDelegate {
    let groupEntryManager = GroupEntryManager()
    private let createNewGroupView = CreateNewGroupView()
    var selectedCategories = Set<CategoryModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(createNewGroupView)
        setupConstraints()
        setupDelegates()
        
        loadCategoryOptions()
    }
    
    private func setupConstraints() {
        createNewGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createNewGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            createNewGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createNewGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createNewGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDelegates() {
        createNewGroupView.delegate = self
        createNewGroupView.categorySelectionView.delegate = self
    }
    
    private func loadCategoryOptions() {
        Task {
            do {
                let categories = try await FirestoreService.shared.fetchCategories()
                createNewGroupView.categorySelectionView.categories = categories
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
    }
}

// MARK: - CreateNewGroupViewDelegate
extension CreateNewGroupViewController {
    func didTouchCreateNewGroupConfirmButton() {
        guard let groupName = validateGroupName(),
              let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance(),
              validateSelectedCategories() else {return}
        
        Task {
            await createNewGroup(groupName: groupName, userUID: userAuthInstance.uid)
        }
    }
    
    private func validateGroupName() -> String? {
        guard let groupName = createNewGroupView.groupNameTextField.text,
              !groupName.isEmpty else {
            AlertUtils.shared.showAlert(self, title: "No group name", message: "Enter a group name in the text field above")
            return nil
        }
        return groupName
    }
    
    private func validateSelectedCategories() -> Bool {
        guard !selectedCategories.isEmpty else {
            AlertUtils.shared.showAlert(self, title: "No group categories selected", message: "Select at least 1 group category")
            return false
        }
        return true
    }
    
    private func createNewGroup(groupName: String, userUID: String) async {
        do {
            let selectedCategoryIDs = selectedCategories.map{ $0.id! }
            let group = GroupModel(groupName: groupName, groupCategoryIDs: selectedCategoryIDs, creatorUID: userUID)
            
            // adds to firestore for both group and group membership async
            let groupID = try groupEntryManager.insertGroup(group: group)
            let groupMembership = GroupMembershipModel(groupID: groupID, userUID: userUID)
            try groupEntryManager.insertGroupMembership(membership: groupMembership)
            AlertUtils.shared.showAlert(self, title: "Debug: Group \(groupName) Created", message: "This is a debug message")
        } catch {
            AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to create a new group.")
        }
    }
}

// MARK: - CategorySelectionViewDelegate
extension CreateNewGroupViewController {
    func didUpdateSelectedCategories(_ selectedCategories: Set<CategoryModel>) {
        self.selectedCategories = selectedCategories
    }
}
