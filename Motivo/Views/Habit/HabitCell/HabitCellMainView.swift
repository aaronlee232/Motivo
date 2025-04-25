//
//  HabitCellMainView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/24/25.
//

import UIKit


protocol HabitCellViewCameraDelegate {
    func onCellCameraButtonTapped(habitWithRecord: HabitWithRecord)
}

protocol HabitCellViewExpansionDelegate {
    func onCellExpandButtonTapped(selectedHabitID: String)
}


class HabitCellMainView: UIView {
    
    // MARK: - UI Elements
    // Habit, Frequency, and Streak
    private let frequencyAndStreakStackView = UIStackView()
    private let frequencyLabel = UILabel()
    private let streakCountLabel = UILabel()
    private let streakSymbol = UIImageView()
    private let habitHeaderStackView = UIStackView()
    private let habitNameLabel = UILabel()
    // Progress and Unit
    private let progressStackView = UIStackView()
    private let progressCountLabel = UILabel()
    private let unitLabel = UILabel()
    // Photo reject and pending stats
    private let photoStatStackView = UIStackView()
    private let pendingCountLabel = UILabel()
    private let rejectCountLabel = UILabel()
    // Camera and expand buttons
    private let buttonStackView = UIStackView()
    private let expansionButton = UIButton()
    private let cameraButton = UIButton()
        
    // Aggregation of all above views
    private let summaryContainerView: UIView = UIView()

    // Cateogry tag collection
    private lazy var categoryTagCollectionView: UICollectionView = self.makeCollectionView()

    // MARK: - Properties
    private var cameraDelegate: HabitCellViewCameraDelegate!
    private var expandDelegate: HabitCellViewExpansionDelegate!
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
        cameraDelegate: HabitCellViewCameraDelegate,
        expandDelegate: HabitCellViewExpansionDelegate,
        withHabitWithRecord habitWithRecord: HabitWithRecord,
        withRejectVotes rejectVotes: [VoteModel],
        categoryIDToName: Dictionary<String, String>,
        isExpanded: Bool
    ) {
        self.cameraDelegate = cameraDelegate
        self.expandDelegate = expandDelegate
        self.habitWithRecord = habitWithRecord
        
        let habit = habitWithRecord.habit
        let record = habitWithRecord.record
        
        habitNameLabel.text = habit.name.capitalized
        frequencyLabel.text = habit.frequency
        streakCountLabel.text = String(habit.streak)
        streakSymbol.image = UIImage(systemName: "flame.fill")
        
        progressCountLabel.text = "\(record.completedCount) / \(habit.goal)"
        unitLabel.text = habit.unit.capitalized
        
        pendingCountLabel.text = "\(record.pendingCount) Pending"
        rejectCountLabel.text = "\(rejectVotes.count) Rejects"
        
        self.categoryIDToName = categoryIDToName
        
        if (isExpanded) {
            expansionButton.tintColor = colorMainPrimary
        } else {
            expansionButton.tintColor = colorMainAccent
        }
        
        cameraButton.addTarget(self, action: #selector(handleCameraButtonTapped), for: .touchUpInside)
        expansionButton.addTarget(self, action: #selector(handleToggleCellExpansionButtonTapped), for: .touchUpInside)

        categoryTagCollectionView.reloadData()
        categoryTagCollectionView.layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    @objc func handleCameraButtonTapped() {
        cameraDelegate.onCellCameraButtonTapped(habitWithRecord: habitWithRecord)
    }
    
    @objc func handleToggleCellExpansionButtonTapped() {
        expandDelegate.onCellExpandButtonTapped(selectedHabitID: habitWithRecord.habit.id)
    }
}


// MARK: - UI Setup
extension HabitCellMainView {
    private func setupUI() {
        setupSummaryContainerView()
        addSubview(categoryTagCollectionView)
        
        categoryTagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryContainerView.topAnchor.constraint(equalTo: topAnchor),
            summaryContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryContainerView.bottomAnchor.constraint(equalTo: categoryTagCollectionView.topAnchor, constant: -8),
            
            categoryTagCollectionView.heightAnchor.constraint(equalToConstant: 50),
            categoryTagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryTagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryTagCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupSummaryContainerView() {
        setupHabitHeaderStackView()
        setupProgressStackView()
        setupPhotoStatStackView()
        setupButtonStackView()
        
        summaryContainerView.addSubview(habitHeaderStackView)
        summaryContainerView.addSubview(photoStatStackView)
        summaryContainerView.addSubview(progressStackView)
        summaryContainerView.addSubview(buttonStackView)
        addSubview(summaryContainerView)
        
        habitHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        photoStatStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        summaryContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitHeaderStackView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor),
            habitHeaderStackView.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor),
            habitHeaderStackView.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor),
            
            photoStatStackView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor),
            photoStatStackView.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 140),
            photoStatStackView.widthAnchor.constraint(equalToConstant: 76),
            photoStatStackView.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor),
            
            progressStackView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor),
            progressStackView.leadingAnchor.constraint(equalTo: photoStatStackView.trailingAnchor, constant: 8),
            progressStackView.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor),

            buttonStackView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: progressStackView.trailingAnchor, constant: 12),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor),
        ])
    }
    
    private func setupHabitHeaderStackView() {
        setupFrequencyAndStreakStackView()
        
        habitNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        habitNameLabel.textColor = colorMainText
        
        habitHeaderStackView.axis = .vertical
        habitHeaderStackView.spacing = 8
        habitHeaderStackView.addArrangedSubview(frequencyAndStreakStackView)
        habitHeaderStackView.addArrangedSubview(habitNameLabel)
    }
    
    private func setupFrequencyAndStreakStackView() {
        let spacer = UIView()
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let fixedWidthSpacer = UIView()
        fixedWidthSpacer.translatesAutoresizingMaskIntoConstraints = false
        fixedWidthSpacer.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
        habitNameLabel.numberOfLines = 1
        frequencyLabel.numberOfLines = 1
        streakCountLabel.numberOfLines = 1
        
        frequencyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        frequencyLabel.textColor = colorMainAccent
        streakCountLabel.textColor = colorMainPrimary
        streakCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        streakSymbol.tintColor = colorMainPrimary
        
        frequencyAndStreakStackView.axis = .horizontal
        frequencyAndStreakStackView.addArrangedSubview(frequencyLabel)
        frequencyAndStreakStackView.addArrangedSubview(fixedWidthSpacer)
        frequencyAndStreakStackView.addArrangedSubview(streakCountLabel)
        frequencyAndStreakStackView.addArrangedSubview(streakSymbol)
        frequencyAndStreakStackView.addArrangedSubview(spacer)
    }
    
    private func setupProgressStackView() {
        progressCountLabel.numberOfLines = 1
        unitLabel.numberOfLines = 1
        
        progressCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        progressCountLabel.textColor = colorMainText
        unitLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        unitLabel.textColor = colorMainText
        
        progressStackView.axis = .vertical
        progressStackView.alignment = .trailing
        progressStackView.spacing = 4
        progressStackView.addArrangedSubview(progressCountLabel)
        progressStackView.addArrangedSubview(unitLabel)
    }
    
    private func setupPhotoStatStackView() {
        pendingCountLabel.numberOfLines = 1
        pendingCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        pendingCountLabel.textColor = colorMainAccent
        rejectCountLabel.numberOfLines = 1
        rejectCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        rejectCountLabel.textColor = colorMainAccent
        
        photoStatStackView.axis = .vertical
        photoStatStackView.spacing = 4
        photoStatStackView.addArrangedSubview(pendingCountLabel)
        photoStatStackView.addArrangedSubview(rejectCountLabel)
    }
    
    private func setupButtonStackView() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        expansionButton.tintColor = colorMainAccent
        expansionButton.setImage(
            UIImage(
                systemName: "rectangle.expand.vertical",
                withConfiguration: symbolConfig
            ),
            for: .normal
        )
        
        cameraButton.tintColor = colorMainAccent
        cameraButton.setImage(
            UIImage(
                systemName: "camera",
                withConfiguration: symbolConfig
            ),
            for: .normal
        )
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.addArrangedSubview(expansionButton)
        buttonStackView.addArrangedSubview(cameraButton)
    }
}

extension HabitCellMainView: UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    private func makeCollectionView() -> UICollectionView {
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
