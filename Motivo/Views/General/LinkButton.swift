//
//  UILinkButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/26/25.
//

import UIKit

class LinkButton: UIButton {
    var fontSize:CGFloat = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLinkButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLinkButtonUI() {
        setTitleColor(colorMainPrimary, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    func changeFontSize(fontSize: Int) {
        self.fontSize = CGFloat(fontSize)
        titleLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
    }
}
