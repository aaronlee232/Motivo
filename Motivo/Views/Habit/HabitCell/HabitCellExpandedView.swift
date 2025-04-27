//
//  HabitCellExpandedView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/24/25.
//

import UIKit
import SwiftUI

class HabitExpandedView: UIView {
    private let pendingPhotoLabel = UILabel()
    private let emptyPendingPhotoLabel = UILabel()
    private var pendingPhotoCollectionView = PendingPhotoCollectionView()
    private var chartHostingController: UIHostingController<HeatMapChartView>?
    private let historicalLabel = UILabel()
    
    private var pendingPhotoCollectionViewCollapseConstraint: NSLayoutConstraint?
    private var historicalLabelTopAnchorConstraint: NSLayoutConstraint!
    
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
        
        emptyPendingPhotoLabel.text = "There are no pending photos"
        emptyPendingPhotoLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        emptyPendingPhotoLabel.textColor = colorMainAccent
        
        historicalLabel.text = "Historicals"
        historicalLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        historicalLabel.textColor = colorMainAccent
        
        addSubview(pendingPhotoLabel)
        addSubview(emptyPendingPhotoLabel)
        addSubview(pendingPhotoCollectionView)
        addSubview(historicalLabel)
        
        // Adding SwiftUI chart for habit "contribution-style chart"
        chartHostingController?.view.removeFromSuperview()
        let chartHostingController = UIHostingController(rootView: HeatMapChartView())
        addSubview(chartHostingController.view)
        
        pendingPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        historicalLabel.translatesAutoresizingMaskIntoConstraints = false
        pendingPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyPendingPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        chartHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pendingPhotoLabel.topAnchor.constraint(equalTo: topAnchor),
            pendingPhotoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pendingPhotoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Shows if there are pending photos
            pendingPhotoCollectionView.topAnchor.constraint(equalTo: pendingPhotoLabel.bottomAnchor, constant: 8),
            pendingPhotoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pendingPhotoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Shows if there are no pending photos
            emptyPendingPhotoLabel.topAnchor.constraint(equalTo: pendingPhotoLabel.bottomAnchor, constant: 8),
            emptyPendingPhotoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyPendingPhotoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            historicalLabel.topAnchor.constraint(equalTo: pendingPhotoCollectionView.bottomAnchor, constant: 16),
            historicalLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            historicalLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Contribution Chart
            chartHostingController.view.topAnchor.constraint(equalTo: historicalLabel.bottomAnchor, constant: 8),
            chartHostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartHostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartHostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartHostingController.view.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        
        historicalLabelTopAnchorConstraint = historicalLabel.topAnchor.constraint(
            equalTo: emptyPendingPhotoLabel.bottomAnchor,
            constant: 16
        )
        historicalLabelTopAnchorConstraint.isActive = true
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
        
        // Hide/Show gallery based on photo list
        let showCollectionView = !imageURLs.isEmpty

        emptyPendingPhotoLabel.isHidden = showCollectionView == true
        pendingPhotoCollectionView.isHidden = showCollectionView == false

        // Remove collapse constraint if showing, add if hiding
        if showCollectionView {
            pendingPhotoCollectionViewCollapseConstraint?.isActive = false
            pendingPhotoCollectionViewCollapseConstraint = nil
        } else {
            if pendingPhotoCollectionViewCollapseConstraint == nil {
                let collapse = pendingPhotoCollectionView.heightAnchor.constraint(equalToConstant: 0)
                collapse.isActive = true
                pendingPhotoCollectionViewCollapseConstraint = collapse
            }
        }
        
        // Remove previous top constraint
        historicalLabelTopAnchorConstraint?.isActive = false

        if showCollectionView {
            historicalLabelTopAnchorConstraint = historicalLabel.topAnchor.constraint(
                equalTo: pendingPhotoCollectionView.bottomAnchor, constant: 16)
        } else {
            historicalLabelTopAnchorConstraint = historicalLabel.topAnchor.constraint(
                equalTo: emptyPendingPhotoLabel.bottomAnchor, constant: 16)
        }
        historicalLabelTopAnchorConstraint.isActive = true
    }
}
