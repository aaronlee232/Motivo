//
//  UISecureGreyTextField.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UISecureGreyTextField: UIGreyTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSecureGreyTextFieldButtonUI()
    }
    
    override init(placeholderText: String) {
        super.init(placeholderText: placeholderText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    private func setupSecureGreyTextFieldButtonUI() {
        isSecureTextEntry = true
    }
}
