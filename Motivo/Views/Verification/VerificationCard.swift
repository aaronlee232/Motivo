//
//  VerificationCard.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/18/25.
//

import UIKit
import Shuffle

// Verification card holds SwipeCard type with extra view inside
class VerificationCard: SwipeCard {
    
    private let username = NormalLabel()
    private let habitName = NormalLabel()
    var usernameView:UIStackView!
    var habitNameView:UIStackView!
    private var imageView:UIImageView!
    private var cardInfoStackView:UIStackView!
    
    // Modified from Shuffle Example
    func card(fromUser user: String, fromHabit habit: String, fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.backgroundColor = .systemBlue
        card.swipeDirections = [.left, .right]
        imageView = UIImageView(image: image)
        
        // Adding user and habit information
        username.text = "Connection: \(user)"
        habitName.text = "Habit: \(habit)"
        
        username.textColor = .white
        habitName.textColor = .white
        
        username.textAlignment = .left
        habitName.textAlignment = .left
        
        usernameView = UIStackView(arrangedSubviews: [username])
        habitNameView = UIStackView(arrangedSubviews: [habitName])
        
        usernameView.backgroundColor = colorMainPrimary
        habitNameView.backgroundColor = colorMainPrimary
        
        usernameView.layer.cornerRadius = username.fontSize / 2
        habitNameView.layer.cornerRadius = habitName.fontSize / 2
        
        usernameView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        habitNameView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        usernameView.isLayoutMarginsRelativeArrangement = true
        habitNameView.isLayoutMarginsRelativeArrangement = true
        
        cardInfoStackView = UIStackView(arrangedSubviews: [usernameView, habitNameView])
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
            cardInfoStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -4)
        ])
        return card
    }
}
