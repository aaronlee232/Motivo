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
    func didTouchRejectButton(direction: SwipeDirection)
    func didTouchAcceptButton(direction: SwipeDirection)
}

class VerificationView: UIView, SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    private let titleLabel = BoldTitleLabel(textLabel: "Verify")
    let cardStack = SwipeCardStack()
    var verificationViewCardData:[CardData] = []
//    var verificationViewCardDataPrev:[CardData] = []
//    var verificationViewCardDataNext:[CardData] = []
    
//    private let previousButton = IconButton(image: UIImage(systemName: "arrow.left")!, barType: false)
//    private let nextButton = IconButton(image: UIImage(systemName: "arrow.right")!, barType: false)
    private let rejectButton = VerifyButton(type: .reject)
    private let acceptButton = VerifyButton(type: .accept)
    
    private let nextConnectionLabel = NormalLabel()
    private let nextConnectionButton = IconButton(image: UIImage(systemName: "arrow.right")!, barType: false)
    
    private let prevConnectionLabel = NormalLabel()
    private let prevConnectionButton = IconButton(image: UIImage(systemName: "arrow.left")!, barType: false)
    
    private var previousNextButtonsStackView:UIStackView!
    private var rejectAcceptButtonsStackView:UIStackView!
    
    // buttons stack - includes next image toggles, x and check buttons
    private var buttonsMainStackView:UIStackView!
    
    // previous connection view - shows previous connection with button or doesn't show if there are no more photos to verify
    private var prevConnectionStackView:UIStackView!
    
    // next connection view - shows next connection with button or doesn't show if there are no more photos to verify
    private var nextConnectionStackView:UIStackView!
    
    private var switchConnectionsStackView:UIStackView!
    
    private let noCardsMessage = NormalLabel(textLabel: "No habits to verify")
    private let noCardsLeftMessage = NormalLabel()
    
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
        
        noCardsMessage.textAlignment = .center
        noCardsMessage.changeFontSize(fontSize: 40)
        
//        previousNextButtonsStackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
//        previousNextButtonsStackView.axis = .horizontal
//        previousNextButtonsStackView.alignment = .center
//        previousNextButtonsStackView.spacing = 0
//        previousNextButtonsStackView.distribution = .equalSpacing
        
        rejectButton.addTarget(self, action: #selector(handleRejectButton), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(handleAcceptButton), for: .touchUpInside)
//        previousButton.addTarget(self, action: #selector(handlePreviousPhotoButton), for: .touchUpInside)
//        nextButton.addTarget(self, action: #selector(handleNextPhotoButton), for: .touchUpInside)
        
        rejectAcceptButtonsStackView = UIStackView(arrangedSubviews: [rejectButton, acceptButton])
        rejectAcceptButtonsStackView.axis = .horizontal
        rejectAcceptButtonsStackView.alignment = .center
        rejectAcceptButtonsStackView.spacing = 0
        rejectAcceptButtonsStackView.distribution = .equalSpacing
        rejectAcceptButtonsStackView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        rejectAcceptButtonsStackView.isLayoutMarginsRelativeArrangement = true
        
//        buttonsMainStackView = UIStackView(arrangedSubviews: [previousNextButtonsStackView, rejectAcceptButtonsStackView])
        buttonsMainStackView = UIStackView(arrangedSubviews: [rejectAcceptButtonsStackView])
        buttonsMainStackView.axis = .vertical
        buttonsMainStackView.alignment = .trailing
        buttonsMainStackView.spacing = 20
        buttonsMainStackView.distribution = .fill
        
        prevConnectionLabel.text = "Previous Connection: "
        prevConnectionLabel.lineBreakMode = .byWordWrapping
        prevConnectionLabel.numberOfLines = 0
        prevConnectionLabel.changeFontSize(fontSize: 14)
        
//        prevConnectionLabel.setContentHuggingPriority(.required, for: .horizontal)
//        prevConnectionButton.setContentHuggingPriority(.required, for: .horizontal)
        
        nextConnectionLabel.text = "Next Connection: "
        nextConnectionLabel.lineBreakMode = .byWordWrapping
        nextConnectionLabel.numberOfLines = 0
        nextConnectionLabel.changeFontSize(fontSize: 14)
        
        // Prevents stretching
//        nextConnectionLabel.setContentHuggingPriority(.required, for: .horizontal)
//        nextConnectionButton.setContentHuggingPriority(.required, for: .horizontal)
        
        prevConnectionStackView = UIStackView(arrangedSubviews: [prevConnectionButton, prevConnectionLabel])
        prevConnectionStackView.axis = .horizontal
        prevConnectionStackView.alignment = .center
        prevConnectionStackView.spacing = 2 // might change to 20
        prevConnectionStackView.distribution = .fill
        
        nextConnectionStackView = UIStackView(arrangedSubviews: [nextConnectionLabel, nextConnectionButton])
        nextConnectionStackView.axis = .horizontal
        nextConnectionStackView.alignment = .center
        nextConnectionStackView.spacing = 2 // might change to 20
        nextConnectionStackView.distribution = .fill
//        nextConnectionStackView.backgroundColor = .systemBlue
        
        switchConnectionsStackView = UIStackView(arrangedSubviews: [prevConnectionStackView, nextConnectionStackView])
        switchConnectionsStackView.axis = .horizontal
        switchConnectionsStackView.alignment = .center
        switchConnectionsStackView.distribution = .equalSpacing
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardStack.translatesAutoresizingMaskIntoConstraints = false
//        previousNextButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        rejectAcceptButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsMainStackView.translatesAutoresizingMaskIntoConstraints = false
        switchConnectionsStackView.translatesAutoresizingMaskIntoConstraints = false
        noCardsMessage.translatesAutoresizingMaskIntoConstraints = false
        noCardsLeftMessage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(cardStack)
        addSubview(buttonsMainStackView)
        addSubview(switchConnectionsStackView)
        addSubview(noCardsMessage)
        addSubview(noCardsLeftMessage)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            cardStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            cardStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cardStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cardStack.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            noCardsMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noCardsMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            noCardsMessage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            noCardsMessage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            noCardsLeftMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noCardsLeftMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            noCardsLeftMessage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            noCardsLeftMessage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
//            previousNextButtonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            previousNextButtonsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            rejectAcceptButtonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rejectAcceptButtonsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            buttonsMainStackView.topAnchor.constraint(equalTo: cardStack.bottomAnchor, constant: 10),
            buttonsMainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsMainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
//            nextConnectionStackView.topAnchor.constraint(equalTo: buttonsMainStackView.bottomAnchor, constant: 20),
//            nextConnectionStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
//            nextConnectionStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            nextConnectionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
//            prevConnectionStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
//            nextConnectionStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            
            switchConnectionsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            switchConnectionsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            switchConnectionsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        noCardsMessage.isHidden = true
        noCardsLeftMessage.isHidden = true
    }
    
    func updateUI() {
        if verificationViewCardData.count == 0 {
            cardStack.isHidden = true
            rejectAcceptButtonsStackView.isHidden = true
            buttonsMainStackView.isHidden = true
            noCardsMessage.isHidden = false
        }
    }
    
    @objc func handleDidSwipeCardAt(index: Int, direction: SwipeDirection) {
        delegate?.didSwipeCardAt(index: index, direction: direction)
    }
    
    @objc func handleRejectButton() {
        delegate?.didTouchRejectButton(direction: .left)
    }
    
    @objc func handleAcceptButton() {
        delegate?.didTouchAcceptButton(direction: .right)
    }
    
    @objc func handlePreviousPhotoButton() {
        print("first time")
        for v in verificationViewCardData {
            print("habit: \(v.habit.name) and timestamp: \(v.record.timestamp)")
        }
        print("end of verificationViewCardData ------------")
//        let currentTopCard = verificationViewCardData[0]
        verificationViewCardData.insert(verificationViewCardData[verificationViewCardData.count - 1], at: 1)
        cardStack.insertCard(atIndex: 1, position: verificationViewCardData.count - 1)
        verificationViewCardData.remove(at: verificationViewCardData.count - 2)
        print("second time")
        for v in verificationViewCardData {
            print("habit: \(v.habit.name) and timestamp: \(v.record.timestamp)")
        }
        print("end of verificationViewCardData ------------")
        cardStack.swipe(.down, animated: true)
//        verificationViewCardData.insert(currentTopCard, at: 1)
    }
    
    @objc func handleNextPhotoButton() {
        let currentTopCard = verificationViewCardData[0]
        cardStack.swipe(.up, animated: true)
        verificationViewCardData.append(currentTopCard)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        // TODO: create a view that makes the card with description of the user and habit, maybe date
        // Create a footer with arrow keys and x and check mark to do the same things that swiping does
        // Another footer if want to skip someone and go to next connection
        let verificationCard = VerificationCard()
        return verificationCard.card(fromUser: verificationViewCardData[index].user.username, fromHabit: verificationViewCardData[index].habit.name, fromImage: verificationViewCardData[index].image, fromDateCompleted: verificationViewCardData[index].record.timestamp)
//        return card(fromImage: cardData[index].image)
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        print("verificationViewCardData: \(verificationViewCardData.count)")
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
        print("inside of didSwipeAllCards")
        noCardsLeftMessage.isHidden = false
    }
}
