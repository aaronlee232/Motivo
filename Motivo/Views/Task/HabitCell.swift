//
//  HabitCell.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//
import UIKit

// MARK: - Custom Habit Cell
class HabitCell: UITableViewCell {
    static let identifier = "HabitCell"
    
    private let nameLabel = UILabel()
    private let groupIconLabel = UILabel()
    private let streakLabel = UILabel()
    private let progressLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    
    private let categoryLabel = UILabel()
    private let statsPlaceholder = UIView()  // Placeholder for heatmap/statistics
    
    var onPlusTapped: (() -> Void)? // Closure for button action
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Configure fonts
        nameLabel.font = .boldSystemFont(ofSize: 16)
        streakLabel.font = .systemFont(ofSize: 14)
        progressLabel.font = .systemFont(ofSize: 14)
        categoryLabel.font = .italicSystemFont(ofSize: 14)
        groupIconLabel.font = .systemFont(ofSize: 16)
        
        // Allow text wrapping for progress label to prevent cutoff
        progressLabel.numberOfLines = 1
        progressLabel.adjustsFontSizeToFitWidth = true
        progressLabel.minimumScaleFactor = 0.8
        
        // Configure plus button
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusButton.tintColor = .blue
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        // Configure stats placeholder (hidden by default)
        statsPlaceholder.backgroundColor = .lightGray
        statsPlaceholder.layer.cornerRadius = 10
        statsPlaceholder.isHidden = true
        
        // Create a horizontal stack for name, group icon, and streak
        let nameStack = UIStackView(arrangedSubviews: [nameLabel, groupIconLabel, streakLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 8
        nameStack.alignment = .leading
        nameStack.distribution = .fillProportionally
        
        // Main stack for compact view (no category)
        let mainStack = UIStackView(arrangedSubviews: [nameStack, progressLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.alignment = .leading
        
        // Expanded stack (includes category & stats)
        let expandedStack = UIStackView(arrangedSubviews: [mainStack, categoryLabel, statsPlaceholder])
        expandedStack.axis = .vertical
        expandedStack.spacing = 4
        
        // Final layout: content + plus button
        let containerStack = UIStackView(arrangedSubviews: [expandedStack, plusButton])
        containerStack.axis = .horizontal
        containerStack.spacing = 8
        containerStack.alignment = .center
        containerStack.distribution = .fill
        
        contentView.addSubview(containerStack)
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            statsPlaceholder.heightAnchor.constraint(equalToConstant: 100)  // Reserved for future statistics
        ])
    }
    
    func configure(with habit: HabitModel, isExpanded: Bool) {
        nameLabel.text = habit.name
        groupIconLabel.text = habit.isGroupHabit ? "👥" : ""
        streakLabel.text = "🔥 \(habit.streak) days"
        progressLabel.text = "\(habit.completed) / \(habit.goal) \(habit.unit) \(habit.frequency)"
        categoryLabel.text = "Category: \(habit.category)"
        
        // Show category and stats only in expanded view
        categoryLabel.isHidden = !isExpanded
        statsPlaceholder.isHidden = !isExpanded
        
        // Gray out fully completed habits
        contentView.alpha = habit.isCompleted ? 0.5 : 1.0
    }
    
    @objc private func plusButtonTapped() {
        onPlusTapped?() // Call the closure when button is tapped
    }
}
