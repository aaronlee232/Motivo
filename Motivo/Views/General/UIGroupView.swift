//
//  UIGroupComponent.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/28/25.
//

import UIKit

class UIGroupView: UIView {
    // Group View size constants
    private let width:CGFloat = 380
    private let height:CGFloat = 80
    
    private let imageView: UIImageView
    private let groupName: UIBoldTitleLabel
    // need to include the label for category types
    private let memberLabel: UISubtitleLabel
    private let memberCountLabel: UINormalLabel
    private let habitsLabel: UISubtitleLabel
    private let habitsCountLabel: UINormalLabel
    
    private var memberHabitsCountStackView: UIStackView!
    private var memberHabitsLabelsStackView: UIStackView!
    private var memberHabitsOverallStackView: UIStackView!
    private var groupNameCategoriesStackView: UIStackView!
    private var mainStackView: UIStackView!
    
    init(image: UIImage, groupName: String, memberCount: Int, habitsCount: Int) {
        imageView = UIImageView(image: image)
        self.groupName = UIBoldTitleLabel(textLabel: groupName)
        self.groupName.changeFontSize(fontSize: 22)
        memberLabel = UISubtitleLabel(textLabel: "Members")
        memberLabel.changeFontSize(fontSize: 16)
        memberCountLabel = UINormalLabel(textLabel: String(memberCount))
        habitsLabel = UISubtitleLabel(textLabel: "Habits")
        habitsLabel.changeFontSize(fontSize: 16)
        habitsCountLabel = UINormalLabel(textLabel: String(habitsCount))
        
        super.init(frame: .zero)
        
        setupGroupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGroupView() {
        
        imageView.contentMode = .scaleAspectFill
        memberHabitsCountStackView = UIStackView(arrangedSubviews: [memberCountLabel, habitsCountLabel])
        memberHabitsCountStackView.axis = .vertical
        
        memberHabitsLabelsStackView = UIStackView(arrangedSubviews: [memberLabel, habitsLabel])
        memberHabitsLabelsStackView.axis = .vertical
        
        memberHabitsOverallStackView = UIStackView(arrangedSubviews: [memberHabitsCountStackView, memberHabitsLabelsStackView])
        memberHabitsOverallStackView.axis = .horizontal
        
        groupNameCategoriesStackView = UIStackView(arrangedSubviews: [groupName]) // TODO: add the categories in later
        groupNameCategoriesStackView.axis = .vertical
        
        mainStackView = UIStackView(arrangedSubviews: [imageView, groupNameCategoriesStackView, memberHabitsOverallStackView])
        
        // Set up to use Auto Layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        groupName.translatesAutoresizingMaskIntoConstraints = false
        memberLabel.translatesAutoresizingMaskIntoConstraints = false
        memberCountLabel.translatesAutoresizingMaskIntoConstraints = false
        habitsLabel.translatesAutoresizingMaskIntoConstraints = false
        habitsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        memberHabitsCountStackView.translatesAutoresizingMaskIntoConstraints = false
        memberHabitsLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        memberHabitsOverallStackView.translatesAutoresizingMaskIntoConstraints = false
        groupNameCategoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.widthAnchor.constraint(equalToConstant: width),
            mainStackView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        addSubview(mainStackView)
    }
}
