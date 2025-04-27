//
//  HabitImageCell.swift
//  Motivo
//
//  Created by Aaron Lee on 4/20/25.
//

import UIKit

class HabitImageCell: UICollectionViewCell {
    static let identifier = "HabitImageCell"
    
    let imageView = UIImageView()
    let captionLabel = UILabel()
    
    private var imageViewBottomToCaptionTop: NSLayoutConstraint!
    private var imageViewBottomToContentBottom: NSLayoutConstraint!
    
    override init (frame:CGRect) {
        super.init(frame: frame)
        
        // Image View
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Caption Label
        captionLabel.numberOfLines = 1
        captionLabel.clipsToBounds = true
        captionLabel.font = UIFont.systemFont(ofSize: 12)
        captionLabel.textColor = colorMainAccent
        captionLabel.isHidden = true  // Hide by default
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(captionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            captionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            captionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
        // Storing dynamic constraint options
        imageViewBottomToCaptionTop = imageView.bottomAnchor.constraint(equalTo: captionLabel.topAnchor)
        imageViewBottomToContentBottom = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        // Start with no caption
        imageViewBottomToContentBottom.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withImageURL imageURL: String, withCaption caption:String?=nil) {
        setImage(withURL: imageURL)
        setCaption(as: caption)
    }
    
    private func setImage(withURL urlString: String) {
        // Using Kingfisher to load from URL
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
    }
    
    private func setCaption(as caption: String?) {
        if let caption = caption, !caption.isEmpty {
            captionLabel.text = caption
            captionLabel.isHidden = false
            imageViewBottomToContentBottom.isActive = false
            imageViewBottomToCaptionTop.isActive = true
        } else {
            captionLabel.text = nil
            captionLabel.isHidden = true
            imageViewBottomToCaptionTop.isActive = false
            imageViewBottomToContentBottom.isActive = true
        }
    }
}
