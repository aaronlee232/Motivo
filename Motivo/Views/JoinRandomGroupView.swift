//
//  JoinRandomGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol JoinRandomGroupViewDelegate:GroupEntryDetailViewController {
    func didTouchJoinRandomGroupConfirmButton()
}

class JoinRandomGroupView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    // TODO: list of buttons of group categories
    let confirmButton = UIButton()
    var delegate:JoinRandomGroupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.text = "Match with a Group"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Join groups with these interests"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        confirmButton.layer.borderColor = UIColor.blue.cgColor
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.cornerRadius = 8.0
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        let viewContainer = UIView()
        viewContainer.addSubview(titleLabel)
        viewContainer.addSubview(subtitleLabel)
        viewContainer.addSubview(confirmButton)
        addSubview(viewContainer)
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Invite Code Label Constraints
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            subtitleLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            // Confirm Button Constraints
            confirmButton.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: viewContainer.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleConfirmButton() {
        delegate?.didTouchJoinRandomGroupConfirmButton()
    }
}
