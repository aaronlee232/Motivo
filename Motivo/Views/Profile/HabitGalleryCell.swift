//
//  HabitGalleryCell.swift
//  Motivo
//
//  Created by Aaron Lee on 4/20/25.
//

import UIKit

class HabitGalleryCell: UITableViewCell {
    static let identifier = "HabitGalleryCell"
    
    let nameLabel = UILabel()
    lazy var collectionView: UICollectionView = self.makeCollectionView()
    
    var imageURLs: [String] = []
    let imageSize = 150
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: HabitPhotoData) {
        nameLabel.text = data.habit.name
        imageURLs = data.imageURLs
        collectionView.reloadData()
    }
}

// MARK: - UI Setup
extension HabitGalleryCell {
    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: imageSize, height: imageSize)
        layout.minimumLineSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(HabitImageCell.self, forCellWithReuseIdentifier: HabitImageCell.identifier)
        return cv
    }
    
    func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(imageSize))
        ])
    }
}

// MARK: - UICollection DataSource
extension HabitGalleryCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HabitImageCell.identifier,
            for: indexPath
        ) as! HabitImageCell
        
        let urlString = imageURLs[indexPath.item]
        cell.setImage(with: urlString)
        return cell
    }
}
