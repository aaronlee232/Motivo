//
//  IconButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/30/25.
//

import UIKit

let miniIconButtonLength:CGFloat = 40

class IconButton: UIButton {
    private var image = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIconButtonUI()
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.image = image
        setupIconButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIconButtonUI() {
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
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
}
