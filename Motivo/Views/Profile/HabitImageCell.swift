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
    
    override init (frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with urlString: String) {
        // Using Kingfisher to load from URL
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
    }

}
