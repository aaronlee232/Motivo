//
//  VerificationView.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/19/25.
//

import UIKit
import Shuffle

protocol VerificationViewDelegate:VerificationViewController {
    func didSwipeCardAt(index: Int, direction: SwipeDirection)
}

class VerificationView: UIView, SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    private let titleLabel = BoldTitleLabel(textLabel: "Verify")
    let cardStack = SwipeCardStack()
    var verificationViewCardData:[CardData] = []
    
    // buttons stack - includes next image toggles, x and check buttons
    private var buttonsStackView:UIStackView!
    
    // next connection view - shows next connection with button or doesn't show if there are no more photos to verify
    private var nextConnectionStackView:UIStackView!
    
    var delegate:VerificationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardStack.delegate = self
        cardStack.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(cardStack)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            cardStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cardStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            cardStack.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    @objc func handleDidSwipeCardAt(index: Int, direction: SwipeDirection) {
        delegate?.didSwipeCardAt(index: index, direction: direction)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        // TODO: create a view that makes the card with description of the user and habit, maybe date
        // Create a footer with arrow keys and x and check mark to do the same things that swiping does
        // Another footer if want to skip someone and go to next connection
        let verificationCard = VerificationCard()
        return verificationCard.card(fromUser: verificationViewCardData[index].user.username, fromHabit: verificationViewCardData[index].habit.name, fromImage: verificationViewCardData[index].image)
//        return card(fromImage: cardData[index].image)
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return verificationViewCardData.count
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        handleDidSwipeCardAt(index: index, direction: direction)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        // Stub
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        // TODO: Let user know all photos for the current user have been reviewed
    }
}
