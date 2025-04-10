//
//  CategoryBadgeView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/9/25.
//

import UIKit

class CategoryBadgesView: UIView, UICollectionViewDelegate {
    var categories: [CategoryModel] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }

    // TODO: fix collection view spacing
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    
        addSubview(collectionView)
        collectionView.register(CategoryBadgeCell.self, forCellWithReuseIdentifier: CategoryBadgeCell.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionView.collectionViewLayout.collectionViewContentSize
    }
}

extension CategoryBadgesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryBadgeCell.reuseIdentifier, for: indexPath) as! CategoryBadgeCell
        cell.configure(with: categories[indexPath.item].name)
        return cell
    }
}
