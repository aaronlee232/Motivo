//
//  ProgressOverview.swift
//  Motivo
//
//  Created by Aaron Lee on 3/28/25.
//

import UIKit

// TODO: Replace with real habit model
struct DummyHabit {
    var name: String
    var habitStatus: HabitStatus
    
    init(name: String, habitStatus: HabitStatus) {
        self.name = name
        self.habitStatus = habitStatus
    }
}

class UserProgressOverviewCell: UITableViewCell {
    
    static let identifier = "HabitProgressOverviewCell"
    
    // MARK: - UI Elements
    let mainStackView = UIStackView() // horizontal container stack
    let profileImageView = UIImageView()
    let contentStackView = UIStackView()
    let expandIndicatorImageView = UIImageView()
    
    let nudgeStackView = UIStackView()
    let nameLabel = UILabel()
    let nudgeLabel = UILabel()
    let nudgeButton = UIButton()
    let progressBarView = UIProgressView(progressViewStyle: .default)
    let spacerView = UIView()
    
    // MARK: - Properties
    private var habitList: [DummyHabit] = [] {
        didSet {
            updateProgressBar()
        }
    }
    
    // MARK: - Initializers
    convenience init(name: String, profileImageURL: String?, habitList: [DummyHabit]) {
        self.init(frame: .zero)
        configureWith(name: name, profileImageURL: profileImageURL, habitList: habitList)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        configureDefaultValues()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension UserProgressOverviewCell {
    private func setupUI() {
        setupMainStackView()
        setupNudgeStackView()
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(profileImageView)
        mainStackView.addArrangedSubview(contentStackView)
        mainStackView.addArrangedSubview(expandIndicatorImageView)
        expandIndicatorImageView.contentMode = .center
        profileImageView.contentMode = .scaleAspectFit
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentStackView.addArrangedSubview(nudgeStackView)
        contentStackView.addArrangedSubview(progressBarView)
    }
    
    private func setupNudgeStackView() {
        nudgeStackView.axis = .horizontal
        nudgeStackView.spacing = 10
        nudgeStackView.addArrangedSubview(nameLabel)
        nudgeStackView.addArrangedSubview(spacerView)
        nudgeStackView.addArrangedSubview(nudgeLabel)
        nudgeStackView.addArrangedSubview(nudgeButton)
        
        // Allow spacerView to take up extra space so other elements are pushed to edges
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

// MARK: - Configuration
extension UserProgressOverviewCell {
    func configureWith(name: String, profileImageURL: String?, habitList: [DummyHabit]) {
        self.nameLabel.text = name
        // replace with kingfisher image loading for profileImageURL ??  UIImage(systemName: "person.crop.circle")
        self.profileImageView.image = UIImage(systemName: "person.crop.circle")
        self.habitList = habitList
    }
    
    private func configureDefaultValues() {
        nudgeLabel.text = "Give em a nudge!"
        nudgeButton.setImage(UIImage(systemName: "megaphone.fill"), for: .normal)
        expandIndicatorImageView.image = UIImage(systemName: "chevron.left")
    }
}

// MARK: - Actions
extension UserProgressOverviewCell {
    func updateExpandIcon(isExpanded: Bool) {
        let chevronIcon = isExpanded ? "chevron.down" : "chevron.left"
        expandIndicatorImageView.image = UIImage(systemName: chevronIcon)
        
        self.layoutIfNeeded()
    }
}


// MARK: - ProgressBar
extension UserProgressOverviewCell {
    func updateProgressBar() {
        let totalHabits = habitList.count
        let completedHabits = habitList.filter { $0.habitStatus == .complete }.count
        
        // Avoid division by zero
        let progress = totalHabits > 0 ? Float(completedHabits) / Float(totalHabits) : 0.0
        
        progressBarView.setProgress(progress, animated: false)
    }
}
