////
////  UserNotInGroupCell.swift
////  Motivo
////
////  Created by Arisyia Wong on 4/27/25.
////
//
//import UIKit
//
//class UserNotInGroupCell: UITableViewCell {
//    static let reuseIdentifier = "UserNotInGroupCell"
//    
//    private let label = NormalLabel()
//    private var username = ""
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configureWith(username: String, isSelected: Bool) {
//        self.username = username
//        label.text = username
//        
//        accessoryType = isSelected ? .checkmark : .none
//    }
//
//    private func setupUI() {
//        
//        label.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//}
