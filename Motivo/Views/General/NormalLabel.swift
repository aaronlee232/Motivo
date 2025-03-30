//
//  UINormalLabel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/28/25.
//

import UIKit

class NormalLabel: UILabel {
    var fontSize:CGFloat = 18
    var currentFont = "Avenir-Light"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNormalLabelUI()
    }
    
    init(textLabel: String) {
        super.init(frame: .zero)
        setupNormalLabelUI()
        text = textLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNormalLabelUI() {
        textColor = colorMainText
        font = UIFont(name: currentFont, size: fontSize)
        textAlignment = .center
    }
    
    func setBoldText(status: Bool) {
        currentFont = status ? "Avenir-Bold" : "Avenir-Light"
        font = UIFont(name: currentFont, size: fontSize)
    }
    
    func changeFontSize(fontSize: Int) {
        self.fontSize = CGFloat(fontSize)
        font = UIFont(name: currentFont, size: self.fontSize)
    }
}
