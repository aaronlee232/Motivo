//
//  VerificationCard.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/18/25.
//

import UIKit
import Foundation
import Shuffle

// Verification card holds SwipeCard type with extra view inside
class VerificationCard: SwipeCard {
    
    private let username = NormalLabel()
    private let habitName = NormalLabel()
    private let dateName = NormalLabel()
    var usernameView:UIStackView!
    var habitNameView:UIStackView!
    var dateNameView:UIStackView!
    private var imageView:UIImageView!
    private var cardInfoStackView:UIStackView!
    
    // Modified from Shuffle Example
    func card(fromUser user: String, fromHabit habit: String, fromImage image: UIImage, fromDateCompleted date: String) -> SwipeCard {
        let card = SwipeCard()
//        card.backgroundColor = .systemBlue
        card.swipeDirections = [.left, .right]
        imageView = UIImageView(image: image)
//        let imageHeight = imageView.image?.size.height ?? 0
//        print("imageHeight: \(imageHeight)")
//        print("imageView.bounds.height: \(imageView.bounds.height)")
//        let bottomAnchorAdjustment = (imageView.bounds.height - imageHeight) / 2
//        print("bottomAnchorAdjustment: \(bottomAnchorAdjustment)")
        
        // Date formatting
        guard let date = ISO8601DateFormatter().date(from: date) else {
            print("Invalid ISO Date string")
            return SwipeCard()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        
        // Adding user and habit information
        username.text = "Connection: \(user)"
        habitName.text = "Habit: \(habit)"
        dateName.text = "Completed on: \(formattedDate)"
        
        username.textColor = .white
        habitName.textColor = .white
        dateName.textColor = .white
        
        username.textAlignment = .left
        habitName.textAlignment = .left
        dateName.textAlignment = .left
        
        usernameView = UIStackView(arrangedSubviews: [username])
        habitNameView = UIStackView(arrangedSubviews: [habitName])
        dateNameView = UIStackView(arrangedSubviews: [dateName])
        
        usernameView.backgroundColor = colorMainPrimary
        habitNameView.backgroundColor = colorMainPrimary
        dateNameView.backgroundColor = colorMainPrimary
        
        usernameView.layer.cornerRadius = username.fontSize / 2
        habitNameView.layer.cornerRadius = habitName.fontSize / 2
        dateNameView.layer.cornerRadius = dateName.fontSize / 2
        
        usernameView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        habitNameView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        dateNameView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        usernameView.isLayoutMarginsRelativeArrangement = true
        habitNameView.isLayoutMarginsRelativeArrangement = true
        dateNameView.isLayoutMarginsRelativeArrangement = true
        
        cardInfoStackView = UIStackView(arrangedSubviews: [usernameView, habitNameView, dateNameView])
        cardInfoStackView.axis = .vertical
        cardInfoStackView.alignment = .leading
        cardInfoStackView.spacing = 4

        cardInfoStackView.layer.masksToBounds = true
        
        imageView.addSubview(cardInfoStackView)
        
        card.content = imageView
        card.content?.contentMode = .scaleAspectFit

        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .systemRed

        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .systemGreen

        card.setOverlays([.left: leftOverlay, .right: rightOverlay])

        cardInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardInfoStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            cardInfoStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            cardInfoStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(1/14 * imageView.bounds.height))
        ])
        return card
    }
}
