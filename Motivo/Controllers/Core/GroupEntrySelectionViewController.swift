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

class GroupEntrySelectionViewController: UIViewController {
    
    private let createNewGroupView = CreateNewGroupView()
    private let joinExistingGroupView = JoinExistingGroupView()
    private let joinRandomGroupView = JoinRandomGroupView()
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
}
