//
//  JoinRandomGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

protocol JoinRandomGroupViewDelegate:JoinRandomGroupViewController {
    func didTouchJoinRandomGroupConfirmButton()
}

class JoinRandomGroupView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let confirmButton = UIButton()
    let categorySelectionView = CategorySelectionView()
    
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
        
        categorySelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        confirmButton.layer.borderColor = UIColor.blue.cgColor
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.cornerRadius = 8.0
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(categorySelectionView)
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Subtitle Code Label Constraints
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Category Selection Constraints
            categorySelectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            categorySelectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categorySelectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categorySelectionView.heightAnchor.constraint(equalToConstant: 300),
            
            // Confirm Button Constraints
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleConfirmButton() {
        delegate?.didTouchJoinRandomGroupConfirmButton()
    }
}
