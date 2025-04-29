//
//  VerifyButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/20/25.
//

import UIKit

enum VerifyButtonStyle {
    case accept
    case reject
}

let verifyButtonDiameter:CGFloat = 80

class VerifyButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVerifyButtonUI()
    }
    
    init(type: VerifyButtonStyle) {
        super.init(frame: .zero)
        if type == .accept {
            setupAcceptVerifyButtonUI()
        } else if type == .reject {
            setupRejectVerifyButtonUI()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAcceptVerifyButtonUI() {
        backgroundColor = colorExtraTeal
        layer.cornerRadius = verifyButtonDiameter / 2
        
        let imageView = UIImageView(image: UIImage(systemName: "checkmark")!)
        imageView.tintColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
        sendSubviewToBack(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: verifyButtonDiameter),
            self.heightAnchor.constraint(equalToConstant: verifyButtonDiameter),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
    
    private func setupRejectVerifyButtonUI() {
        backgroundColor = colorExtraBrightRed
        layer.cornerRadius = verifyButtonDiameter / 2
        
        let imageView = UIImageView(image: UIImage(systemName: "xmark")!)
        imageView.tintColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
        sendSubviewToBack(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: verifyButtonDiameter),
            self.heightAnchor.constraint(equalToConstant: verifyButtonDiameter),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
    
    // Default circle button of color main primary
    private func setupVerifyButtonUI() {
        backgroundColor = colorMainPrimary
        layer.cornerRadius = verifyButtonDiameter / 2
        
        let imageView = UIImageView()
        imageView.tintColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
        sendSubviewToBack(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: verifyButtonDiameter),
            self.heightAnchor.constraint(equalToConstant: verifyButtonDiameter),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
}
