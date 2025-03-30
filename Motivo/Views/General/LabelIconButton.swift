//
//  GroupEntryButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/29/25.
//

import UIKit

let buttonLength:CGFloat = 150

class LabelIconButton: UIButton {
    private var image = UIImage(systemName: "exclamationmark.triangle")
    private var title = NormalLabel(textLabel: "Not Defined")
    private var mainStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainStackView = UIStackView()
        setupLabelIconButtonUI()
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.image = image
        setupLabelIconButtonUI()
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = NormalLabel(textLabel: title)
        setupLabelIconButtonUI()
    }
    
    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        self.image = image
        self.title = NormalLabel(textLabel: title)
        setupLabelIconButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupLabelIconButtonUI() {
        backgroundColor = .systemBackground
        layer.borderColor = colorMainAccent.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 0.1 * buttonLength
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = colorMainAccent
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        title.changeFontSize(fontSize: 20)
        
        mainStackView = UIStackView(arrangedSubviews: [imageView, title])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        imageView.isUserInteractionEnabled = false
        title.isUserInteractionEnabled = false
        mainStackView.isUserInteractionEnabled = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        sendSubviewToBack(mainStackView)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: buttonLength),
            self.heightAnchor.constraint(equalToConstant: buttonLength),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: buttonLength),
            mainStackView.heightAnchor.constraint(equalToConstant: buttonLength)
        ])
    }
}
