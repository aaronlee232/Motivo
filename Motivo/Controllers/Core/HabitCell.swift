//
//  HabitCell.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//


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
        nameLabel.font = .boldSystemFont(ofSize: 16)
        streakLabel.font = .systemFont(ofSize: 14)
        progressLabel.font = .systemFont(ofSize: 14)
        categoryLabel.font = .italicSystemFont(ofSize: 14)
        groupIconLabel.font = .systemFont(ofSize: 16)
        
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusButton.tintColor = .blue
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        statsPlaceholder.backgroundColor = .lightGray  // Placeholder section
        statsPlaceholder.layer.cornerRadius = 10
        statsPlaceholder.isHidden = true
        
        let nameStack = UIStackView(arrangedSubviews: [nameLabel, groupIconLabel, streakLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 8
        nameStack.alignment = .leading
        
        let mainStack = UIStackView(arrangedSubviews: [nameStack, progressLabel, categoryLabel, statsPlaceholder])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        
        let containerStack = UIStackView(arrangedSubviews: [mainStack, plusButton])
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
    
    func configure(with habit: Habit, isExpanded: Bool) {
        nameLabel.text = habit.name
        groupIconLabel.text = habit.isGroupHabit ? "👥" : ""
        streakLabel.text = "🔥 \(habit.streak) days"
        progressLabel.text = "\(habit.completed) / \(habit.goal) \(habit.unit) \(habit.frequency)"
        categoryLabel.text = "Category: \(habit.category)"
        
        statsPlaceholder.isHidden = !isExpanded  // Show stats section only in expanded mode
    }
    
    @objc private func plusButtonTapped() {
        onPlusTapped?() // Call the closure when button is tapped
    }
}
