//
//  HabitCellExpandedView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/24/25.
//

import UIKit

class HabitExpandedView: UIView {
    private let pendingPhotoLabel = UILabel()
    private var pendingPhotoCollectionView = PendingPhotoCollectionView()
    private let historicalLabel = UILabel()
    
    private var habitWithRecord: HabitWithRecord!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        pendingPhotoLabel.text = "Pending Photos"
        pendingPhotoLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        pendingPhotoLabel.textColor = colorMainAccent
        
        historicalLabel.text = "Historicals"
        historicalLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        historicalLabel.textColor = colorMainAccent
        
        addSubview(pendingPhotoLabel)
        addSubview(historicalLabel)
        addSubview(pendingPhotoCollectionView)
        
        pendingPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        historicalLabel.translatesAutoresizingMaskIntoConstraints = false
        pendingPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pendingPhotoLabel.topAnchor.constraint(equalTo: topAnchor),
            pendingPhotoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pendingPhotoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            pendingPhotoCollectionView.topAnchor.constraint(equalTo: pendingPhotoLabel.bottomAnchor, constant: 8),
            pendingPhotoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pendingPhotoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            historicalLabel.topAnchor.constraint(equalTo: pendingPhotoCollectionView.bottomAnchor, constant: 16),
            historicalLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            historicalLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            historicalLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // TODO: Historical heatmap
        ])
    }

    func configure(withHabitWithRecord habitWithRecord: HabitWithRecord) {
        self.habitWithRecord = habitWithRecord
        
        let imageURLs = habitWithRecord.record.unverifiedPhotoURLs
        var imageURLToRejectCount = Dictionary<String, Int>()
        for imageURL in imageURLs {
            imageURLToRejectCount[imageURL] = 0
        }
        
        // For quick lookup
        let imageURLSet = Set(imageURLs)
        for vote in habitWithRecord.rejectVotes {
            // Safety check to ensure votes are for displayed images
            if (!imageURLSet.contains(vote.photoURL)) {
                continue
            }
            
            imageURLToRejectCount[vote.photoURL]! += 1
        }
        
        pendingPhotoCollectionView.configure(
            withImageURLs: imageURLs,
            withImageURLtoRejectCount: imageURLToRejectCount
        )
    }
}
