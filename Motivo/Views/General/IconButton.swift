//
//  IconButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/30/25.
//

import UIKit

class IconButton: UIButton {
    private let barButtonLength:CGFloat = 40
    private let miniIconButtonLength:CGFloat = 32
    private var padding:CGFloat = 8
    
    private var image = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image: UIImage, barType: Bool, padding: CGFloat = 8) {
        self.init(frame: .zero)

        self.padding = padding
        self.image = image
        if barType {
            setupBarIconButtonUI()
        } else {
            setupImageIconButtonUI()
        }
    }

    convenience init(padding: CGFloat) {
        self.init(frame: .zero)
        self.padding = padding
        setupTextIconButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageIconButtonUI() {
        backgroundColor = colorMainPrimary
        layer.cornerRadius = 0.3 * miniIconButtonLength
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        
        addSubview(imageView)
        sendSubviewToBack(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: miniIconButtonLength),
            self.heightAnchor.constraint(equalToConstant: miniIconButtonLength),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        ])
    }
    
    private func setupTextIconButtonUI() {
        backgroundColor = colorMainPrimary
        layer.cornerRadius = 0.3 * miniIconButtonLength
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func setupBarIconButtonUI() {
        backgroundColor = .systemBackground
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = colorMainAccent
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        addSubview(imageView)
        sendSubviewToBack(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: barButtonLength),
            self.heightAnchor.constraint(equalToConstant: barButtonLength),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }
}
