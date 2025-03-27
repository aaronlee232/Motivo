//
//  ConfirmButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UIConfirmButton: UIActionButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfirmButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfirmButtonUI() {
        setTitle("CONFIRM", for: .normal)
    }
}
