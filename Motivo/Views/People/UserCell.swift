//
//  ContactCell.swift
//  Motivo
//
//  Created by Aaron Lee on 3/11/25.
//

import UIKit

class UserCell: UITableViewCell {
    static let identifier = "UserCell"
    
    let nameLabel = UILabel()
    let counterButton = UIButton(type: .system)  // Tracks number of photos waiting verification
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        counterButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(counterButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            counterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            counterButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: UserModel) {
        nameLabel.text = user.username
        counterButton.setTitle("\(user.unverifiedPhotos)", for: .normal)
    }
}

