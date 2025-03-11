//
//  JoinRandomGroupView.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

import UIKit

class JoinRandomGroupView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    // TODO: list of buttons of group categories
    let confirmButton = UIButton()
    
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
        
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Join groups with these interests"
        
        confirmButton.layer.borderColor = UIColor.blue.cgColor
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.cornerRadius = 8.0
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, confirmButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}
