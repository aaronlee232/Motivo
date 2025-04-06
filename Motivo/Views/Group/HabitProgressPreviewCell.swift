//
//  HabitPreviewCell.swift
//  Motivo
//
//  Created by Aaron Lee on 3/28/25.
//

import UIKit

enum HabitStatus: Int, Comparable {
    case complete = 0
    case pending = 1
    case incomplete = 2
    
    static func < (lhs: HabitStatus, rhs: HabitStatus) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

class HabitProgressPreviewCell: UITableViewCell {
    
    // MARK: - UI Elements
    static let identifier = "HabitProgressPreviewCell"

    private let mainStackView = UIStackView()
    private let statusImageView = UIImageView()
    private let habitNameLabel = UILabel()
    private let spacerView = UIView()
    private let messageLabel = UILabel()
    
    // MARK: - Initializers
    init(habitStatus: HabitStatus, habitName: String) {
        self.init(frame: .zero)
        configureWith(habitStatus: habitStatus, habitName: habitName)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Cell Configuration
extension HabitProgressPreviewCell {
    func configureWith(habitStatus: HabitStatus, habitName: String) {
        self.habitNameLabel.text = habitName
        self.statusImageView.image = statusImage(for: habitStatus)
        self.messageLabel.text = message(for: habitStatus)
        
        // Hide messageLabel if it's nil
        messageLabel.isHidden = (messageLabel.text == nil)
    }
    
    private func statusImage(for habitStatus: HabitStatus) -> UIImage {
        switch habitStatus {
        case .incomplete:
            return UIImage(systemName: "circle")!
        case .pending:
            return UIImage(systemName: "clock.circle.fill")!
        case .complete:
            return UIImage(systemName: "checkmark.circle.fill")!
        }
    }
    
    private func message(for habitStatus: HabitStatus) -> String? {
        switch habitStatus {
        case .incomplete, .complete:
            return nil
        case .pending:
            return "(Pending)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        habitNameLabel.text = nil
        statusImageView.image = nil
        messageLabel.text = nil
    }
}

// MARK: - UI Setup
extension HabitProgressPreviewCell {
    private func setupUI() {
        setupMainStackView()

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(statusImageView)
        mainStackView.addArrangedSubview(habitNameLabel)
        mainStackView.addArrangedSubview(spacerView)
        mainStackView.addArrangedSubview(messageLabel)
        
        statusImageView.contentMode = .scaleAspectFit
        
        // Allow spacerView to take up extra space so other elements are pushed to edges
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(mainStackView)
    }
}
