//
//  UISubtitleLabel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class SubtitleLabel: UILabel {
    var fontSize:CGFloat = 24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubtitleLabelUI()
    }
    
    init(textLabel: String) {
        super.init(frame: .zero)
        setupSubtitleLabelUI()
        text = textLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubtitleLabelUI() {
        textColor = colorMainText
        font = UIFont.systemFont(ofSize: fontSize)
        alpha = 0.5 // setting opacity
        textAlignment = .center
    }
    
    func changeFontSize(fontSize: Int) {
        self.fontSize = CGFloat(fontSize)
        font = UIFont.boldSystemFont(ofSize: self.fontSize)
    }
}
