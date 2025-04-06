//
//  UIGroupComponent.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/28/25.
//

import UIKit

class GroupCell: UITableViewCell {
    
    static let identifier = "groupCellIdentifier"
    
    // Group View size constants
    static let groupViewWidth:CGFloat = 380
    static let groupViewHeight:CGFloat = 80
    static let groupViewDeadSpace:CGFloat = 20
    
    private var groupID: String!
    private var profileImageView = UIImageView()
    private var groupName = BoldTitleLabel()
    private var categories:[String] = []
    private var memberLabel = SubtitleLabel(textLabel: "Members")
    private var memberCountLabel = NormalLabel()
    private var habitsLabel = SubtitleLabel(textLabel: "Habits")
    private var habitsCountLabel = NormalLabel()
    
    private var memberHabitsCountStackView: UIStackView!
    private var memberHabitsLabelsStackView: UIStackView!
    private var memberHabitsOverallStackView: UIStackView!
    private var categoriesStackView1: UIStackView!
    private var categoriesStackView2: UIStackView! // in case there are more than 3 labels
    private var groupNameCategoriesStackView: UIStackView!
    private var mainStackView: UIStackView!
    private var spaceView: UIView!
    
//    init(groupId: String, image: UIImage, groupName: String, categories: [String], memberCount: Int, habitsCount: Int) {
//        self.init(frame: .zero)
//        configureWith(groupId: groupId, image: image, groupName: groupName, categories: categories, memberCount: memberCount, habitsCount: habitsCount)
//    }
//    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGroupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(groupID: String, image: UIImage, groupName: String, categories: [String], memberCount: Int, habitsCount: Int) {
        self.groupID = groupID
        self.profileImageView.image = image
        self.groupName.text = groupName
        self.categories = categories
        self.memberCountLabel.text = String(memberCount)
        self.habitsCountLabel.text = String(habitsCount)
//        print("Inside configureWith")
//        print("GroupId: \(self.groupId)")
//        print("GroupName: \(self.groupName)")
//        print("Categories: \(self.categories)")
//        print("Member Count: \(self.memberCountLabel)")
//        print("Habit Count: \(self.habitsCountLabel)")
        setupGroupView()
    }
    
    private func setupGroupView() {
//        layer.borderColor = colorMainPrimary.cgColor
//        layer.borderWidth = 2
//        layer.cornerRadius = 0.1875 * GroupCell.groupViewHeight
//        selectionStyle = .none // prevents the user from seeing that the table view cell is clicked
        profileImageView.tintColor = colorMainText
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = colorMainText.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = (GroupCell.groupViewHeight - (4 * 2)) / 2
        
        groupName.changeFontSize(fontSize: 22)
        groupName.textAlignment = .left
        
        memberLabel.changeFontSize(fontSize: 16)
        memberLabel.textAlignment = .left
        
        memberCountLabel.setBoldText(status: true)
        
        habitsLabel.changeFontSize(fontSize: 16)
        habitsLabel.textAlignment = .left
        
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
        categoriesStackView1.spacing = 8
        categoriesStackView1.alignment = .fill
        categoriesStackView1.distribution = .fillEqually
        
        if self.categories.count > 3 {
            categoriesStackView2 = UIStackView()
            categoriesStackView2.axis = .horizontal
            categoriesStackView2.spacing = 8
            categoriesStackView2.alignment = .fill
            categoriesStackView2.distribution = .fillEqually
        }
        for string in self.categories.prefix(3) {
            let categoryLabel = createCategoryLabels(categoryString: string)
            categoriesStackView1.addArrangedSubview(categoryLabel)
        }
        if self.categories.count > 3 {
            for string in categories.suffix(from: 3) {
                let categoryLabel = createCategoryLabels(categoryString: string)
                categoriesStackView2.addArrangedSubview(categoryLabel)
            }
        }
        
        groupNameCategoriesStackView = categories.count > 3 ?
            UIStackView(arrangedSubviews: [groupName, categoriesStackView1, categoriesStackView2]):
            UIStackView(arrangedSubviews: [groupName, categoriesStackView1])
        groupNameCategoriesStackView.axis = .vertical
        
        mainStackView = UIStackView(arrangedSubviews: [profileImageView, groupNameCategoriesStackView, memberHabitsOverallStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .center
        mainStackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4) // padding
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        mainStackView.layer.borderColor = colorMainPrimary.cgColor
        mainStackView.layer.borderWidth = 2
        mainStackView.layer.cornerRadius = 0.1875 * GroupCell.groupViewHeight
        
        memberHabitsOverallStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        memberHabitsOverallStackView.setContentHuggingPriority(.required, for: .horizontal)
        groupNameCategoriesStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        groupNameCategoriesStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        mainStackView.backgroundColor = .red
        
//        spaceView = UIView()

//        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // Set up to use Auto Layout
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        contentView.addSubview(mainStackView)
//        contentView.addSubview(spaceView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: GroupCell.groupViewHeight - (4 * 2)),
            profileImageView.heightAnchor.constraint(equalToConstant: GroupCell.groupViewHeight - (4 * 2)),
            groupNameCategoriesStackView.widthAnchor.constraint(equalToConstant: 0.50 * GroupCell.groupViewWidth),
            mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: GroupCell.groupViewWidth),
            mainStackView.heightAnchor.constraint(equalToConstant: GroupCell.groupViewHeight),
//            spaceView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
//            spaceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // enable tap feature so user can go to group details

//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
//        mainStackView.addGestureRecognizer(tapGestureRecognizer)
//        mainStackView.isUserInteractionEnabled = true
    }
    
    // Action when group view component is tapped
//    @objc func stackViewTapped() {
//        UIView.animate(withDuration: 0.2) {
//            self.mainStackView.backgroundColor = colorMainText.withAlphaComponent(0.4)
//            self.mainStackView.backgroundColor = .systemBackground
//        }
//        print("Group view tapped!")
//    }
//    
    private func createCategoryLabels(categoryString: String) -> UILabel {
        let categoryLabel = NormalLabel(textLabel: categoryString)
//        let categoryLabel = UILabel()
        categoryLabel.text = categoryString
        categoryLabel.textAlignment = .center
        categoryLabel.changeFontSize(fontSize: 10)
        categoryLabel.layer.borderColor = colorMainPrimary.cgColor
        categoryLabel.layer.borderWidth = 2
        categoryLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return categoryLabel
    }

}
