//
//  UIBoldTitleLabel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class UIBoldTitleLabel: UILabel {
    var fontSize:CGFloat = 32
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoldTitleLabelUI()
    }
    
    init(textLabel: String) {
        super.init(frame: .zero)
        setupBoldTitleLabelUI()
        text = textLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoldTitleLabelUI() {
        textColor = colorMainText
        font = UIFont.boldSystemFont(ofSize: fontSize)
        textAlignment = .center
    }
    
    func changeFontSize(fontSize: Int) {
        self.fontSize = CGFloat(fontSize)
        font = UIFont.boldSystemFont(ofSize: self.fontSize)
    }
}
