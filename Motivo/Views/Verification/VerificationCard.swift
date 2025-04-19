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
    private var imageView:UIImageView!
    private var cardInfoStackView:UIStackView!
    
    // Modified from Shuffle Example
    func card(fromUser user: String, fromHabit habit: String, fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.backgroundColor = .systemBlue
        card.swipeDirections = [.left, .right]
        imageView = UIImageView(image: image)
//        imageView.backgroundColor = .systemYellow
//        card.content = UIImageView(image: image)
        
        // Adding user and habit information
        username.text = user
        habitName.text = habit
        
        username.textAlignment = .left
        habitName.textAlignment = .left
        
        cardInfoStackView = UIStackView(arrangedSubviews: [username, habitName])
        cardInfoStackView.axis = .vertical
        cardInfoStackView.alignment = .leading
        cardInfoStackView.spacing = 2
        
        imageView.addSubview(cardInfoStackView)
        
        card.content = imageView
        card.content?.contentMode = .scaleAspectFit

        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .systemRed

        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .systemGreen

        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        
//        cardInfoStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
//        card.addSubview(cardInfoStackView)

        cardInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            cardInfoStackView.topAnchor.constraint(equalTo: card.bottomAnchor),
            cardInfoStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            cardInfoStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            cardInfoStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        return card
    }
}
