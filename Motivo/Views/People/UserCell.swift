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
    var habitWithRecords: [HabitWithRecord]?
    
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
    
    func configure(withUser user: UserModel, withHabitWithRecords habitWithRecords: [HabitWithRecord], withVotedPhotoSet votedPhotoSet: Set<VotedPhoto>) {
        nameLabel.text = user.username
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
    }
}

