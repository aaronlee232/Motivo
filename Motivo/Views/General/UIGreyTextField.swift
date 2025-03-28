//
//  UIGreyTextField.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UIGreyTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGreyTextFieldButtonUI()
    }
    
    init(placeholderText: String, isSecure: Bool) {
        super.init(frame: .zero)
        if isSecure {
            setupSecureText()
        }
        setupGreyTextFieldButtonUI()
        placeholder = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    private func setupGreyTextFieldButtonUI() {
        backgroundColor = colorMainSecondary
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: colorExtraPlaceholderText])
        autocapitalizationType = .none
    }
    
    private func setupSecureText() {
        isSecureTextEntry = true
        text = text // reload to make sure that text is hidden
    }
}
