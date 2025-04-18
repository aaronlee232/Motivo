//
//  HabitInfoCell.swift
//  Motivo
//
//  Created by Aaron Lee on 4/11/25.
//

import UIKit

class HabitInfoCell: UITableViewCell {
    static let identifier = "HabitInfoCell"
    
    // MARK: - UI Elements
    private let habitNameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let goalCountLabel = UILabel()
    private let unitLabel = UILabel()
    private let frequencyLabel = UILabel()
    
    private let mainStackView = UIStackView()
    private let habitNameAndUserStackView = UIStackView()
    private let goalStackView = UIStackView()
    private let metricsStackView = UIStackView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(habit: HabitModel, user: UserModel) {
        habitNameLabel.text = habit.name
        usernameLabel.text = user.username
        goalCountLabel.text = String(habit.goal)
        unitLabel.text = habit.unit
        frequencyLabel.text = habit.frequency
    }
}

// MARK: - UI Setup
extension HabitInfoCell {
    private func setupUI() {
        setupLabelStyles()
        setupStacks()
        setupBackground()

        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupLabelStyles() {
        habitNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.font = .systemFont(ofSize: 14, weight: .regular)
        usernameLabel.textColor = .secondaryLabel

        goalCountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        unitLabel.font = .systemFont(ofSize: 14, weight: .medium)
        frequencyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        frequencyLabel.textColor = .secondaryLabel

        habitNameLabel.numberOfLines = 1
        usernameLabel.numberOfLines = 1
        frequencyLabel.numberOfLines = 1
    }
    
    private func setupStacks() {
        habitNameAndUserStackView.axis = .vertical
        habitNameAndUserStackView.spacing = 4
        habitNameAndUserStackView.addArrangedSubview(habitNameLabel)
        habitNameAndUserStackView.addArrangedSubview(usernameLabel)

        goalStackView.axis = .horizontal
        goalStackView.spacing = 4
        goalStackView.addArrangedSubview(goalCountLabel)
        goalStackView.addArrangedSubview(unitLabel)

        metricsStackView.axis = .vertical
        metricsStackView.spacing = 4
        metricsStackView.alignment = .trailing
        metricsStackView.addArrangedSubview(goalStackView)
        metricsStackView.addArrangedSubview(frequencyLabel)

        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        mainStackView.isLayoutMarginsRelativeArrangement = true

        mainStackView.addArrangedSubview(habitNameAndUserStackView)
        mainStackView.addArrangedSubview(metricsStackView)
    }
    
    private func setupBackground() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
}
