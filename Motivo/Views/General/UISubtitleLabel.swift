//
//  UISubtitleLabel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UISubtitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubtitleLabelUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubtitleLabelUI() {
        textColor = colorMainText
        font = UIFont.systemFont(ofSize: 24)
        alpha = 0.5 // setting opacity
        textAlignment = .center
    }
}
