//
//  UIGreyTextField.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class GreyTextField: UITextField {
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
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: colorExtraPlaceholderText])
        autocapitalizationType = .none
    }
    
    private func setupSecureText() {
        isSecureTextEntry = true
        text = text // reload to make sure that text is hidden
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
}
