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
    private let frequencyAndStreakStackView = UIStackView()
    private let frequencyLabel = UILabel()
    private let streakCountLabel = UILabel()
    private let streakSymbol = UIImageView()
    
    private let habitHeaderStackView = UIStackView()
    private let habitNameLabel = UILabel()
    
    private let progressStackView = UIStackView()
    private let progressCountLabel = UILabel()
    private let unitLabel = UILabel()
    
    private let photoStatStackView = UIStackView()
    private let pendingCountLabel = UILabel()
    private let rejectCountLabel = UILabel()
    
    private let buttonStackView = UIStackView()
    private let expansionButton = UIButton()
    private let cameraButton = UIButton()

    // MARK: - Properties
    private var cameraDelegate: HabitCellViewCameraDelegate!
    private var expandDelegate: HabitCellViewExpansionDelegate!
    private var habitWithRecord: HabitWithRecord!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        if (isExpanded) {
            expansionButton.tintColor = colorMainPrimary
        } else {
            expansionButton.tintColor = colorMainAccent
        }
        
        cameraButton.addTarget(self, action: #selector(handleCameraButtonTapped), for: .touchUpInside)
        expansionButton.addTarget(self, action: #selector(handleToggleCellExpansionButtonTapped), for: .touchUpInside)
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
        let spacer = UIView()
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let fixedWidthSpacer1 = UIView()
        fixedWidthSpacer1.translatesAutoresizingMaskIntoConstraints = false
        fixedWidthSpacer1.widthAnchor.constraint(equalToConstant: 8).isActive = true
        let fixedWidthSpacer2 = UIView()
        fixedWidthSpacer2.translatesAutoresizingMaskIntoConstraints = false
        fixedWidthSpacer2.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        setupHabitHeaderStackView()
        setupProgressStackView()
        setupPhotoStatStackView()
        setupButtonStackView()
        
        addSubview(habitHeaderStackView)
        addSubview(photoStatStackView)
        addSubview(progressStackView)
        addSubview(buttonStackView)
        
        habitHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        photoStatStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitHeaderStackView.topAnchor.constraint(equalTo: topAnchor),
            habitHeaderStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            habitHeaderStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            photoStatStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 140), // Column
            photoStatStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoStatStackView.widthAnchor.constraint(equalToConstant: 76),
            
            progressStackView.leadingAnchor.constraint(equalTo: photoStatStackView.trailingAnchor, constant: 8),
            progressStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            buttonStackView.leadingAnchor.constraint(equalTo: progressStackView.trailingAnchor, constant: 12),
            buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
