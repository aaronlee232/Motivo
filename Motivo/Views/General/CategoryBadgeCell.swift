//
//  CategoryBadgeCell.swift
//  Motivo
//
//  Created by Aaron Lee on 4/9/25.
//

import UIKit

class CategoryBadgeCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryBadgeCell"
    
    private let paddingView = UIView()
    private let badgeLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            // paddingView fills cell with outer margin
            paddingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            paddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            paddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            paddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // badgeLabel has inner padding from the paddingView
            badgeLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 4),
            badgeLabel.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -4),
            badgeLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 12),
            badgeLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupUI() {
        paddingView.backgroundColor = .systemBlue
        paddingView.layer.cornerRadius = 12
        paddingView.clipsToBounds = true
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: String) {
        badgeLabel.text = category
    }
}
