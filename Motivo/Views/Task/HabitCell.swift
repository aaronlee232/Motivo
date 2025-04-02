//
//  HabitCell.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/11/25.
//
import UIKit

class HabitCell: UITableViewCell {
    static let identifier = "HabitCell"

    private let nameLabel = UILabel()
    private let progressLabel = UILabel()
    private let plusButton = UIButton(type: .system)

    var onPlusTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        progressLabel.font = .systemFont(ofSize: 14)

        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusButton.tintColor = .blue
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameLabel, progressLabel, plusButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            plusButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with habit: HabitModel, progressText: String) {
        nameLabel.text = habit.name
        progressLabel.text = progressText
    }

    @objc private func plusButtonTapped() {
        onPlusTapped?()
    }
}
