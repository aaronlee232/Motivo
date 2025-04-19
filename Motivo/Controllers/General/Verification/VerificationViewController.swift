//
//  VerificationViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 4/14/25.
//

import UIKit
import Shuffle
import Kingfisher

struct CardData {
    let image: UIImage
    let photoURL: String
    let habit: HabitModel
    let record: HabitRecord
    
    // TODO: ...Other info to display on card
}

class VerificationViewController: UIViewController {
    // MARK: - UI Elements
    let cardStack = SwipeCardStack()
    
    // MARK: - Properties
    let verificationManager = VerificationManager()
    var user: UserModel!
    var habitWithRecordsByUserUID: Dictionary<String, [HabitWithRecord]>?
    var cardData: [CardData] = []
    
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
    
    func configureWith(user: UserModel, habitWithRecordsByUserUID: Dictionary<String, [HabitWithRecord]>, votedPhotoSet: Set<VotedPhoto>) {
        Task {
            do {
                self.user = user
                guard let habitWithRecords = habitWithRecordsByUserUID[user.id] else {
                    return
                }
                
                for entry in habitWithRecords {
                    for url in entry.record.unverifiedPhotoURLs {
                        // Skip photos that have already been seen by the current user
                        if (votedPhotoSet.contains(VotedPhoto(habitRecordID: entry.record.id, photoURL: url))) {
                            continue
                        }
                        
                        let image = try await ImageDownloader.fetchImage(from: url)
                        cardData.append(
                            CardData(
                                image: image,
                                photoURL: url,
                                habit: entry.habit,
                                record: entry.record
                            )
                        )
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
        return card(fromImage: cardData[index].image)
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardData.count
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        Task {
            do {
                // Retrieve logged in user's auth instance
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    print("Error: No authenticated user.")
                    return
                }
                
                switch direction {
                case .left:
                    // Create reject vote for userID and photoURL at index
                    let vote = VoteModel(
                        voterUID: userAuthInstance.uid,
                        habitRecordID: cardData[index].record.id,
                        photoURL: cardData[index].photoURL,
                        voteType: VoteType.reject,
                        timestamp: ISO8601DateFormatter().string(from: Date())
                    )
                    try verificationManager.addVote(vote)
                case .right:
                    // Create accept vote for userID and photoURL at index
                    let vote = VoteModel(
                        voterUID: userAuthInstance.uid,
                        habitRecordID: cardData[index].record.id,
                        photoURL: cardData[index].photoURL,
                        voteType: VoteType.accept,
                        timestamp: ISO8601DateFormatter().string(from: Date())
                    )
                    try verificationManager.addVote(vote)
                    
                    // Move photoURL from unverified list to verified list in active habit record
                    try await verificationManager.approvePhoto(
                        withPhotoURL: cardData[index].photoURL,
                        forHabitRecordID: cardData[index].record.id
                    )
                default:
                    break
                }
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to verify photo")
            }
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        // Stub
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        // TODO: Let user know all photos for the current user have been reviewed
    }
}
