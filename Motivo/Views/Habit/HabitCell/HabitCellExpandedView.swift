//
//  HabitCellExpandedView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/24/25.
//

import UIKit

class HabitExpandedView: UIView {
    private let pendingPhotoLabel = UILabel()
    private let historicalLabel = UILabel()
    
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
        
        pendingPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        historicalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pendingPhotoLabel.topAnchor.constraint(equalTo: topAnchor),
            pendingPhotoLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            pendingPhotoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pendingPhotoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            historicalLabel.topAnchor.constraint(equalTo: topAnchor),
            historicalLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            historicalLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            historicalLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure() {
        // TODO: Populate image and vote data
    }
}
