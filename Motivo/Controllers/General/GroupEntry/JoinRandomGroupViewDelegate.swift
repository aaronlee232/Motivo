//
//  GroupEntryRandomJoinViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import UIKit

class JoinRandomGroupViewController: UIViewController, JoinRandomGroupViewDelegate {
    let groupMatchingManager = GroupMatchingManager()
    private let joinRandomGroupView = JoinRandomGroupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(joinRandomGroupView)
        setupConstraints()
        
        joinRandomGroupView.delegate = self
    }
    
    private func setupConstraints() {
        joinRandomGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinRandomGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            joinRandomGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            joinRandomGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            joinRandomGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didTouchJoinRandomGroupConfirmButton() {
        // TODO: Implement join random group
        return
    }

}
