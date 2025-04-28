//
//  ProfileView.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/2/25.
//

import UIKit

protocol ProfileViewDelegate:ProfileViewController {
    func didTouchSettingsButton()
}

struct CompletedStats {
    var daily: Int
    var weekly: Int
    var monthly: Int
    var total: Int
}

struct UserStats {
    let habitCount: Int
    let groupCount: Int
    let completed: CompletedStats
}

class ProfileView: UIView {
    
    // MARK: - UI Elements
    let headerView = ProfileHeaderView()
    private let groupsLabel = NormalLabel(textLabel: "Groups")
    let groupTableView = GroupTableView()
    private let galleryLabel = NormalLabel(textLabel: "Gallery")
    let galleryTableView = GalleryTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        delegate: ProfileViewDelegate,
        withUsername username: String,
        withUserStats userStats: UserStats,
        withGroupMetadataList groupMetadataList: [GroupMetadata],
        withHabitsWithImages habitsWithImages: [HabitPhotoData],
        isViewingOtherProfile isOtherProfile: Bool
    ) {
        
        // Profile header
        headerView.delegate = delegate
        headerView.configure(withUsername: username, withUserStats: userStats, isOtherProfile: isOtherProfile)
        
        // Group list
        groupTableView.delegate = delegate
        groupTableView.configure(withGroupMetadataList: groupMetadataList)
        
        // Gallery
        galleryTableView.configureWith(habitsWithImages: habitsWithImages)
        galleryTableView.reloadData()
    }
    
    private func setupUI() {
        setupHeaderView()
        setupGroupListDisplay()
        setupGalleryDisplay()
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            groupsLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            groupsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//             TODO: change NormalLabel alignment to be adjustable. Add trailing constraint once done
            groupTableView.topAnchor.constraint(equalTo: groupsLabel.bottomAnchor, constant: 10),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            groupTableView.heightAnchor.constraint(equalToConstant: 200),

            galleryLabel.topAnchor.constraint(equalTo: groupTableView.bottomAnchor),
            galleryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            // TODO: change NormalLabel alignment to be adjustable. Add trailing constraint once done
            galleryTableView.topAnchor.constraint(equalTo: galleryLabel.bottomAnchor, constant: 10),
            galleryTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            galleryTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            galleryTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
    }
    
    private func setupGroupListDisplay() {
        groupsLabel.setBoldText(status: true)

        groupsLabel.translatesAutoresizingMaskIntoConstraints = false
        groupTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(groupsLabel)
        addSubview(groupTableView)
    }
    
    private func setupGalleryDisplay() {
        galleryLabel.setBoldText(status: true)
        
        galleryLabel.translatesAutoresizingMaskIntoConstraints = false
        galleryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(galleryLabel)
        addSubview(galleryTableView)
    }
}


class ProfileHeaderView: UIView {
    let profileImageViewHeight:CGFloat = 50
    
    // bar button
    let settingsButton = IconButton(image: UIImage(systemName: "gear")!, barType: true)
    
    let titleLabel = BoldTitleLabel(textLabel: "My Profile")
    private let profileImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    var usernameLabel = NormalLabel()
    var myHabitsCountLabel = NormalLabel(textLabel: "0")
    private let myHabitsLabel = SubtitleLabel(textLabel: "Habits")
    var myGroupsCountLabel = NormalLabel(textLabel: "0")
    private let myGroupsLabel = SubtitleLabel(textLabel: "Groups")
    var myCompletedCountButton = UIButton(type: .system)
    private var myCompletedCountButtonLabel = NormalLabel(textLabel: "0") // completed count number
    private let myCompletedCountButtonImageView = UIImageView(image: UIImage(systemName: "info.square"))
    private let myCompletedLabel = SubtitleLabel(textLabel: "Completed")
    
    private var userInfoStackView: UIStackView!
    private var habitsStackView: UIStackView!
    private var groupsStackView: UIStackView!
    private var completedStackView: UIStackView!
    private var completedSubStackView: UIStackView!
    private var statsStackView: UIStackView!
    
    var delegate:ProfileViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withUsername username: String, withUserStats userStats: UserStats, isOtherProfile: Bool) {
        if isOtherProfile {
            titleLabel.text = "\(username)'s Profile"
            settingsButton.isHidden = true
        }
        usernameLabel.text = username
        myHabitsCountLabel.text = String(userStats.habitCount)
        myGroupsCountLabel.text = String(userStats.groupCount)
        
        let menu = UIMenu(title: "Completed Habits", children: [
            UIAction(title: "Daily: \(userStats.completed.daily)", attributes: .disabled, handler: { _ in }),
            UIAction(title: "Weekly: \(userStats.completed.weekly)", attributes: .disabled, handler: { _ in }),
            UIAction(title: "Monthly: \(userStats.completed.monthly)", attributes: .disabled, handler: { _ in })
        ])

        myCompletedCountButtonLabel.text = String(userStats.completed.total)
        myCompletedCountButtonLabel.setBoldText(status: true)
        
        myCompletedCountButtonImageView.tintColor = colorMainText
        myCompletedCountButtonImageView.contentMode = .scaleAspectFit
        myCompletedCountButtonImageView.clipsToBounds = true
        
        completedSubStackView = UIStackView(arrangedSubviews: [myCompletedCountButtonLabel, myCompletedCountButtonImageView])
        completedSubStackView.axis = .horizontal
        completedSubStackView.alignment = .center
        completedSubStackView.spacing = 4
        
        completedSubStackView.translatesAutoresizingMaskIntoConstraints = false
        myCompletedCountButton.addSubview(completedSubStackView)

//        myCompletedCountButtonLabel.frame = myCompletedCountButton.bounds
//        myCompletedCountButtonLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myCompletedCountButton.showsMenuAsPrimaryAction = true
        myCompletedCountButton.menu = menu
        NSLayoutConstraint.activate([
            myCompletedCountButton.heightAnchor.constraint(equalToConstant: myHabitsCountLabel.frame.height)
        ])
    }

    private func setupUI() {
        setupTitleBar()
        setupProfileImage()
        setupUserStatsDisplay()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupTitleBar() {
        settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
        titleLabel.textAlignment = .center
        
        // Add to view
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    private func setupUserStatsDisplay() {
        // Habit Count Stat
        myHabitsCountLabel.setBoldText(status: true)
        myHabitsLabel.changeFontSize(fontSize: 16)
        habitsStackView = UIStackView(arrangedSubviews: [myHabitsCountLabel, myHabitsLabel])
        habitsStackView.axis = .vertical
        habitsStackView.alignment = .center
        habitsStackView.distribution = .equalSpacing
        
        // Group Count Stat
        myGroupsCountLabel.setBoldText(status: true)
        myGroupsLabel.changeFontSize(fontSize: 16)
        groupsStackView = UIStackView(arrangedSubviews: [myGroupsCountLabel, myGroupsLabel])
        groupsStackView.axis = .vertical
        groupsStackView.alignment = .center
        groupsStackView.distribution = .equalSpacing
        
        // Completed Count Stat
//        myCompletedCountLabel.setBoldText(status: true)
        
        myCompletedLabel.changeFontSize(fontSize: 16)
        completedStackView = UIStackView(arrangedSubviews: [myCompletedCountButton, myCompletedLabel])
        completedStackView.axis = .vertical
        completedStackView.alignment = .center
        completedStackView.distribution = .equalSpacing
//        myCompletedLabel.changeFontSize(fontSize: 16)
//        completedSubStackView = UIStackView(arrangedSubviews: [myCompletedCountButton, myCompletedLabel])
//        completedSubStackView.axis = .vertical
//        completedSubStackView.alignment = .center
//        completedSubStackView.distribution = .equalSpacing
//        
//        completedStackView = UIStackView(arrangedSubviews: [completedSubStackView, myCompletedCountButtonImageView])
//        completedStackView.axis = .horizontal
//        completedStackView.alignment = .center
//        completedStackView.spacing = 4
        
        // User Info
        userInfoStackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        userInfoStackView.axis = .horizontal
        userInfoStackView.alignment = .center
        userInfoStackView.spacing = 1
        
        // Combined User Stat Display
        statsStackView = UIStackView(arrangedSubviews: [userInfoStackView, habitsStackView, groupsStackView, completedStackView])
        statsStackView.axis = .horizontal
        statsStackView.alignment = .center
        statsStackView.spacing = 2
        statsStackView.distribution = .fillProportionally
        
        // Add to view
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsStackView)
    }
    
    private func setupProfileImage() {
        profileImageView.tintColor = colorMainPrimary
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.borderColor = colorMainText.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = profileImageViewHeight / 2
        profileImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewHeight)
        ])
    }
    
    @objc func handleSettingsButton() {
        delegate?.didTouchSettingsButton()
    }
}
