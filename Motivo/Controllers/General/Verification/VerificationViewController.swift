//
//  VerificationViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 4/14/25.
//

import UIKit
import Shuffle

class VerificationViewController: UIViewController {
    let cardStack = SwipeCardStack()
    
    private let cardImages: [UIImage] = [
        UIImage(named: "cardImage1")!,
        UIImage(named: "cardImage2")!,
        UIImage(named: "cardImage3")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardStack)
        
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cardStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        cardStack.dataSource = self
        cardStack.delegate = self
        cardStack.reloadData()
    }
    
    func card(fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = UIImageView(image: image)
        card.content?.contentMode = .scaleAspectFit

        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .systemRed

        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .systemGreen

        card.setOverlays([.left: leftOverlay, .right: rightOverlay])

        return card
    }
}

extension VerificationViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return card(fromImage: cardImages[index])
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardImages.count
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("swiped: \(direction.description)")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        // Stub
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        // TODO: Let user know all photos have been reviewed and pop navigation controller to connections page
    }
}
