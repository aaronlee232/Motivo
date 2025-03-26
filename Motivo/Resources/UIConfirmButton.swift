//
//  ConfirmButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UIConfirmButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfirmButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // function runs after layout is calculated
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2 // rounded corners based off of height
        self.layer.masksToBounds = true // corner radius applies to contents inside the button
    }
    
    private func setupConfirmButtonUI() {
        backgroundColor = colorMainPrimary
        setTitleColor(colorMainBackground, for: .normal)
        // titleLabel?.font
        setTitle("CONFIRM", for: .normal)
    }
}
