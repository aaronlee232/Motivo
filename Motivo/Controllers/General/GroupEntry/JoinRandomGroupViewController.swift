//
//  GroupEntryRandomJoinViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import UIKit

class JoinRandomGroupViewController: UIViewController, JoinRandomGroupViewDelegate, CategorySelectionViewDelegate {    
    let groupMatchingManager = GroupMatchingManager()
    private let joinRandomGroupView = JoinRandomGroupView()
    var selectedCategories = Set<CategoryModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(joinRandomGroupView)
        setupConstraints()
        setupDelegates()
        
        loadCategoryOptions()
    }
    
    private func setupConstraints() {
        joinRandomGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinRandomGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            joinRandomGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            joinRandomGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            joinRandomGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDelegates() {
        joinRandomGroupView.delegate = self
        joinRandomGroupView.categorySelectionView.delegate = self
    }
    
    private func loadCategoryOptions() {
        // TODO: Replace with Firestore fetch
        joinRandomGroupView.categorySelectionView.categories = categories
    }
}

// MARK: - CreateNewGroupViewDelegate
extension JoinRandomGroupViewController {
    func didTouchJoinRandomGroupConfirmButton() {
        guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
            AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
            return
        }
        
        groupMatchingManager.joinRandomGroup(with: Array(selectedCategories), as: user.uid)
    }
}

// MARK: - CategorySelectionViewDelegate
extension JoinRandomGroupViewController {
    func didUpdateSelectedCategories(_ selectedCategories: Set<CategoryModel>) {
        self.selectedCategories = selectedCategories
    }
}
