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
    private let streakLabel = UILabel()
    private let categoryLabel = UILabel()
    private let groupEmojiLabel = UILabel()
    private let progressLabel = UILabel()
    private let plusButton = UIButton(type: .system)

    var onPlusTapped: (() -> Void)?
    private var habit: HabitModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 18)

        streakLabel.font = .systemFont(ofSize: 12) // Smaller font for streak number
        streakLabel.textColor = .darkGray

        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textColor = .gray

        groupEmojiLabel.font = .systemFont(ofSize: 14)

        progressLabel.font = .systemFont(ofSize: 14)
        progressLabel.textAlignment = .right // Right align progress text

        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusButton.tintColor = .blue
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        let nameStack = UIStackView(arrangedSubviews: [nameLabel, streakLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 6
        nameStack.alignment = .center

        let bottomStack = UIStackView(arrangedSubviews: [categoryLabel, groupEmojiLabel])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 6
        bottomStack.alignment = .center

        let leftStack = UIStackView(arrangedSubviews: [nameStack, bottomStack])
        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.alignment = .leading

        let containerStack = UIStackView(arrangedSubviews: [leftStack, progressLabel, plusButton])
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
            progressLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80) // Ensure progress text doesn't shrink too much
        ])
    }

    func configure(with habit: HabitModel, progressText: String) {
        self.habit = habit

        nameLabel.text = habit.name
        streakLabel.text = "🔥 \(habit.streak)" // Smaller streak label

        categoryLabel.text = "Categories: \(habit.categoryIDs.joined(separator: ", "))"  // TODO: fetch in VC and pass in /populate here

        progressLabel.text = progressText
    }

    @objc private func plusButtonTapped() {
        Task {
            do {
                guard let habit = habit else { return }
                
                let existingRecords = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)

                // Task Verification Code added here -> This should add an unverified photo to the list, not directly increment completedCount
                
                if let existingRecord = existingRecords.first {
//                    var updatedRecord = existingRecord
//                    updatedRecord.completedCount += 1
//                    try FirestoreService.shared.updateHabitRecord(habitRecord: updatedRecord)
                } else {
                    let newHabitRecord = HabitRecord(habitID: habit.id,
                                                     unverifiedPhotoURLs: [],
                                                     verifiedPhotoURLs: [],
                                                     timestamp: Date().formatted(),
                                                     userUID: habit.userUID)
                    try FirestoreService.shared.addHabitRecord(habitRecord: newHabitRecord)
                }
                
                onPlusTapped?()
            } catch {
                print("Error updating habit record: \(error.localizedDescription)")
            }
        }
    }
}
