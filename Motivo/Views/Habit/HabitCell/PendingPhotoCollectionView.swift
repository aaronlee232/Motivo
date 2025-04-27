//
//  PendingPhotoCollectionView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/25/25.
//

import UIKit

class PendingPhotoCollectionView: UIView {
    
    private lazy var collectionView: UICollectionView = self.makeCollectionView()
    
    private var imageURLs: [String] = []
    private var imageURLtoRejectCount = Dictionary<String, Int>()
    private let imageSize = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        withImageURLs imageURLs: [String],
        withImageURLtoRejectCount imageURLtoRejectCount: Dictionary<String, Int>
    ) {
        self.imageURLs = imageURLs
        self.imageURLtoRejectCount = imageURLtoRejectCount
        collectionView.reloadData()
    }
}

// MARK: - UI Setup
extension PendingPhotoCollectionView {
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
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(imageSize))
        ])
    }
}

// MARK: - UICollection DataSource
extension PendingPhotoCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HabitImageCell.identifier,
            for: indexPath
        ) as! HabitImageCell
        
        let urlString = imageURLs[indexPath.item]
        let caption = "Rejects: \(imageURLtoRejectCount[urlString]!)"
        cell.configure(withImageURL: urlString, withCaption: caption)
        return cell
    }
}
