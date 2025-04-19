//
//  VerificationViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 4/14/25.
//

import UIKit
import Shuffle
import Kingfisher

class VerificationViewController: UIViewController {
    // MARK: - UI Elements
    let cardStack = SwipeCardStack()
    
    // MARK: - Properties
    var user: UserModel?
    var habitWithRecordsByUserUID: Dictionary<String, [HabitWithRecord]>?
    var cardImages: [UIImage] = []
    
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
    
    func configureWith(user: UserModel, habitWithRecordsByUserUID: Dictionary<String, [HabitWithRecord]>) {
        Task {
            do {
                let habitWithRecords = habitWithRecordsByUserUID[user.id] ?? []
                for entry in habitWithRecords {
                    for url in entry.record.unverifiedPhotoURLs {
                        let image = try await ImageDownloader.fetchImage(from: url)
                        cardImages.append(image)
                    }
                }
            } catch {
                print("Failed to fetch image: \(error)")
            }
            cardStack.reloadData()
        }
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
        // TODO: create a view that makes the card with description of the user and habit, maybe date
        // Create a footer with arrow keys and x and check mark to do the same things that swiping does
        // Another footer if want to skip someone and go to next connection
        let verificationCard = VerificationCard()
        return verificationCard.card(fromUser: "user", fromHabit: "habit", fromImage: cardImages[index])
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
