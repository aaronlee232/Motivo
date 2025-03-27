//
//  UIBoldTitleLabel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UIBoldTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoldTitleLabelUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoldTitleLabelUI() {
        textColor = colorMainText
        font = UIFont.boldSystemFont(ofSize: 32)
        textAlignment = .center
    }
}
