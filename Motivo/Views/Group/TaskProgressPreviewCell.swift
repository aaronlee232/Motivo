//
//  TaskPreviewCell.swift
//  Motivo
//
//  Created by Aaron Lee on 3/28/25.
//

import UIKit

enum TaskStatus: Int, Comparable {
    case complete = 0
    case pending = 1
    case incomplete = 2
    
    static func < (lhs: TaskStatus, rhs: TaskStatus) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

class TaskProgressPreviewCell: UITableViewCell {
    
    // MARK: - UI Elements
    static let identifier = "TaskPreviewCell"

    private let mainStackView = UIStackView()
    private let statusImageView = UIImageView()
    private let taskNameLabel = UILabel()
    private let spacerView = UIView()
    private let messageLabel = UILabel()
    
    // MARK: - Initializers
    init(taskStatus: TaskStatus, taskName: String) {
        self.init(frame: .zero)
        configureWith(taskStatus: taskStatus, taskName: taskName)
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
extension TaskProgressPreviewCell {
    func configureWith(taskStatus: TaskStatus, taskName: String) {
        self.taskNameLabel.text = taskName
        self.statusImageView.image = statusImage(for: taskStatus)
        self.messageLabel.text = message(for: taskStatus)
        
        // Hide messageLabel if it's nil
        messageLabel.isHidden = (messageLabel.text == nil)
    }
    
    private func statusImage(for taskStatus: TaskStatus) -> UIImage {
        switch taskStatus {
        case .incomplete:
            return UIImage(systemName: "circle")!
        case .pending:
            return UIImage(systemName: "clock.circle.fill")!
        case .complete:
            return UIImage(systemName: "checkmark.circle.fill")!
        }
    }
    
    private func message(for taskStatus: TaskStatus) -> String? {
        switch taskStatus {
        case .incomplete, .complete:
            return nil
        case .pending:
            return "(Pending)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskNameLabel.text = nil
        statusImageView.image = nil
        messageLabel.text = nil
    }
}

// MARK: - UI Setup
extension TaskProgressPreviewCell {
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
        mainStackView.addArrangedSubview(taskNameLabel)
        mainStackView.addArrangedSubview(spacerView)
        mainStackView.addArrangedSubview(messageLabel)
        
        statusImageView.contentMode = .scaleAspectFit
        
        // Allow spacerView to take up extra space so other elements are pushed to edges
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(mainStackView)
    }
}
