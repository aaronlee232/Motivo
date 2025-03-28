//
//  UINormalLabel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/28/25.
//

import UIKit

class NormalLabel: UILabel {
    var fontSize:CGFloat = 18
    
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
        font = UIFont(name: "Avenir-Light", size: fontSize)
        textAlignment = .center
    }
    
    func setBoldText() {
        font = UIFont(name: "Avenir-Bold", size: fontSize)
    }
    
    func changeFontSize(fontSize: Int) {
        self.fontSize = CGFloat(fontSize)
        font = UIFont.boldSystemFont(ofSize: self.fontSize)
    }
}
