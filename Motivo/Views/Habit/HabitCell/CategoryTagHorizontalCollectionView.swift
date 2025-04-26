//
//  CategoryTagHorizontalCollectionView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/25/25.
//

import UIKit

class CategoryTagHorizontalCollectionView: UIView {
    // MARK: - UI Elements
    private lazy var categoryTagCollectionView: UICollectionView = self.makeCategoryTagCollectionView()
    
    // MARK: - Properties
    private var habitWithRecord: HabitWithRecord!
    private var categoryIDToName: Dictionary<String, String>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryTagCollectionView.delegate = self
        categoryTagCollectionView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(
        withHabitWithRecord habitWithRecord: HabitWithRecord,
        withCategoryIDToName categoryIDToName: Dictionary<String, String>
    ) {
        self.habitWithRecord = habitWithRecord
        self.categoryIDToName = categoryIDToName
        
        categoryTagCollectionView.reloadData()
        categoryTagCollectionView.layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
}

// MARK: - UI Setup
extension CategoryTagHorizontalCollectionView {
    private func setupUI() {
        addSubview(categoryTagCollectionView)
        
        categoryTagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50),
            
            categoryTagCollectionView.topAnchor.constraint(equalTo: topAnchor),
            categoryTagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryTagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryTagCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


// MARK: - UICollectionView methods
extension CategoryTagHorizontalCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habitWithRecord.habit.categoryIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryBadgeCell.reuseIdentifier, for: indexPath) as! CategoryBadgeCell
        let categories = habitWithRecord.habit.categoryIDs.map { categoryIDToName[$0]! }
        cell.configure(with: categories[indexPath.item])
        
        return cell
    }
    
    override var intrinsicContentSize: CGSize {
        return categoryTagCollectionView.collectionViewLayout.collectionViewContentSize
    }
    
    private func makeCategoryTagCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 100  // TODO: Find a better fix for preventing line wrap
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = true
        cv.register(CategoryBadgeCell.self, forCellWithReuseIdentifier: CategoryBadgeCell.reuseIdentifier)
        return cv
    }
}
