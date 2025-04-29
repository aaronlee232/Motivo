//
//  ContactCell.swift
//  Motivo
//
//  Created by Aaron Lee on 3/11/25.
//

import UIKit

protocol UserCellDelegate: ConnectionsViewController {
    func counterTapped(forUser user: UserModel)
    func toggleFavorite(forUserID userID: String)
}

class UserCell: UITableViewCell {
    static let identifier = "UserCell"
    
    let nameLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    let counterButton = IconButton(padding: 8)
    var habitWithRecords: [HabitWithRecord]?
    private var user: UserModel!
    private var delegate: UserCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        favoriteButton.tintColor = colorMainAccent
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        counterButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(counterButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favoriteButton.trailingAnchor.constraint(equalTo: counterButton.leadingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            counterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            counterButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        withDelegate delegate: UserCellDelegate,
        withUser user: UserModel,
        isFavorite: Bool,
        withHabitWithRecords habitWithRecords: [HabitWithRecord],
        withVotedPhotoSet votedPhotoSet: Set<VotedPhoto>
    ) {
        self.delegate = delegate
        
        // Set cell username
        self.user = user
        nameLabel.text = user.username
       
        // Set favorite symbol
        if (isFavorite) {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        favoriteButton.addTarget(self, action: #selector(handleFavoriteTapped), for: .touchUpInside)
        
        // Set Pending Photo Count
        self.habitWithRecords = habitWithRecords
        var unverifiedPhotoCount = 0
        habitWithRecords.forEach { entry in
            // Ignore photos that have been seen and voted on
            let unseenPhotoURLs = entry.record.unverifiedPhotoURLs.filter {
                !votedPhotoSet.contains(VotedPhoto(habitRecordID: entry.record.id, photoURL: $0))
            }
            unverifiedPhotoCount += unseenPhotoURLs.count
        }
        
        counterButton.setTitle("\(unverifiedPhotoCount)", for: .normal)
        counterButton.addTarget(self, action: #selector(handleCounterTapped), for: .touchUpInside)
    }
    
    @objc func handleCounterTapped() {
        delegate.counterTapped(forUser: user)
    }
    
    @objc func handleFavoriteTapped() {
        delegate.toggleFavorite(forUserID: user.id)
    }
}

