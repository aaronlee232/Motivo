//
//  UIGroupComponent.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/28/25.
//

import UIKit

// Group View size constants
let groupViewWidth:CGFloat = 380
let groupViewHeight:CGFloat = 80

class GroupView: UIView {
    
    private let imageView: UIImageView
    private let groupName: BoldTitleLabel
    private let categories: [String]
    private let memberLabel: SubtitleLabel
    private let memberCountLabel: NormalLabel
    private let habitsLabel: SubtitleLabel
    private let habitsCountLabel: NormalLabel
    
    private var memberHabitsCountStackView: UIStackView!
    private var memberHabitsLabelsStackView: UIStackView!
    private var memberHabitsOverallStackView: UIStackView!
    private var categoriesStackView1: UIStackView!
    private var categoriesStackView2: UIStackView! // in case there are more than 3 labels
    private var groupNameCategoriesStackView: UIStackView!
    private var mainStackView: UIStackView!
    
    init(image: UIImage, groupName: String, categories: [String], memberCount: Int, habitsCount: Int) {
        imageView = UIImageView(image: image)
        self.groupName = BoldTitleLabel(textLabel: groupName)
        self.groupName.changeFontSize(fontSize: 22)
        self.categories = categories
        memberLabel = SubtitleLabel(textLabel: "Members")
        memberLabel.changeFontSize(fontSize: 16)
        memberCountLabel = NormalLabel(textLabel: String(memberCount))
        habitsLabel = SubtitleLabel(textLabel: "Habits")
        habitsLabel.changeFontSize(fontSize: 16)
        habitsCountLabel = NormalLabel(textLabel: String(habitsCount))
        
        super.init(frame: .zero)
        
        setupGroupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGroupView() {
        layer.borderColor = colorMainPrimary.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 0.1875 * groupViewHeight
        imageView.tintColor = colorMainText
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = colorMainText.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = (groupViewHeight - (4 * 2)) / 2
        memberCountLabel.setBoldText(status: true)
        habitsCountLabel.setBoldText(status: true)
        
        memberHabitsCountStackView = UIStackView(arrangedSubviews: [memberCountLabel, habitsCountLabel])
        memberHabitsCountStackView.axis = .vertical
        
        memberHabitsLabelsStackView = UIStackView(arrangedSubviews: [memberLabel, habitsLabel])
        memberHabitsLabelsStackView.axis = .vertical
        
        memberHabitsOverallStackView = UIStackView(arrangedSubviews: [memberHabitsCountStackView, memberHabitsLabelsStackView])
        memberHabitsOverallStackView.axis = .horizontal
        memberHabitsOverallStackView.alignment = .center
        
        categoriesStackView1 = UIStackView()
        categoriesStackView1.axis = .horizontal
        categoriesStackView1.spacing = 10
        categoriesStackView1.alignment = .fill
        categoriesStackView1.distribution = .fillEqually
        
        if categories.count > 3 {
            categoriesStackView2 = UIStackView()
            categoriesStackView2.axis = .horizontal
            categoriesStackView2.spacing = 10
            categoriesStackView2.alignment = .fill
            categoriesStackView2.distribution = .fillEqually
        }
        for string in categories.prefix(3) {
            let categoryLabel = createCategoryLabels(categoryString: string)
            categoriesStackView1.addArrangedSubview(categoryLabel)
        }
        if categories.count > 3 {
            for string in categories.suffix(from: 3) {
                let categoryLabel = createCategoryLabels(categoryString: string)
                categoriesStackView2.addArrangedSubview(categoryLabel)
            }
        }
        
        groupNameCategoriesStackView = categories.count > 3 ?
            UIStackView(arrangedSubviews: [groupName, categoriesStackView1, categoriesStackView2]):
            UIStackView(arrangedSubviews: [groupName, categoriesStackView1])
        groupNameCategoriesStackView.axis = .vertical
        
        mainStackView = UIStackView(arrangedSubviews: [imageView, groupNameCategoriesStackView, memberHabitsOverallStackView])
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .fill
        mainStackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4) // padding
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.arrangedSubviews[2].setContentCompressionResistancePriority(.required, for: .horizontal)
        mainStackView.arrangedSubviews[2].setContentHuggingPriority(.required, for: .horizontal)
        mainStackView.arrangedSubviews[1].setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        mainStackView.arrangedSubviews[1].setContentHuggingPriority(.defaultLow, for: .horizontal)

        
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
        categoriesStackView1.translatesAutoresizingMaskIntoConstraints = false
        groupNameCategoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: groupViewHeight - (4 * 2)),
            imageView.heightAnchor.constraint(equalToConstant: groupViewHeight - (4 * 2)),
//            mainStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: mainStackView.arrangedSubviews[2].leadingAnchor),
            groupNameCategoriesStackView.widthAnchor.constraint(equalToConstant: 0.55 * groupViewWidth),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: groupViewWidth),
            mainStackView.heightAnchor.constraint(equalToConstant: groupViewHeight),
        ])
        
        // enable tap feature so user can go to group details
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    // Action when group view component is tapped
    @objc func stackViewTapped() {
        UIView.animate(withDuration: 0.2) {
            self.mainStackView.backgroundColor = colorMainText.withAlphaComponent(0.4)
            self.mainStackView.backgroundColor = .systemBackground
        }
        print("Group view tapped!")
        // TODO: segue to group details
    }
    
    private func createCategoryLabels(categoryString: String) -> NormalLabel {
        let categoryLabel = NormalLabel(textLabel: categoryString)
        categoryLabel.textAlignment = .center
        categoryLabel.changeFontSize(fontSize: 10)
        categoryLabel.layer.borderColor = colorMainPrimary.cgColor
        categoryLabel.layer.borderWidth = 2
        categoryLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return categoryLabel
    }
}
