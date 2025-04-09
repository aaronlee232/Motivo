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

class ProfileView: UIView {
    
    static let profileImageViewHeight:CGFloat = 50
    
    let groupTableView = GroupTableView()
    private var tableView = UITableView()
    
    // bar button
    let settingsButton = IconButton(image: UIImage(systemName: "gear")!, barType: true)
    
    private let titleLabel = BoldTitleLabel(textLabel: "My Profile")
    private let profileImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    private let username = NormalLabel()
    private let myHabitsCountLabel = NormalLabel(textLabel: "0")
    private let myHabitsLabel = SubtitleLabel(textLabel: "Habits")
    private let myGroupsCountLabel = NormalLabel(textLabel: "0")
    private let myGroupsLabel = SubtitleLabel(textLabel: "Groups")
    private let myDaysCountLabel = NormalLabel(textLabel: "0")
    private let myDaysLabel = SubtitleLabel(textLabel: "Days")
    private let groupsLabel = NormalLabel(textLabel: "Groups")
    
    private var userInfoStackView: UIStackView!
    private var habitsStackView: UIStackView!
    private var groupsStackView: UIStackView!
    private var daysStackView: UIStackView!
    private var statsStackView: UIStackView!
    
    var delegate:ProfileViewDelegate?
    var groupList:[GroupMetadata] = [] {
        didSet {
            groupTableView.updateTableData(givenList: groupList)
            tableView.reloadData()
            setupData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = groupTableView.tableView
        Task {
            do {
                let username = try await FirestoreService.shared.fetchCurrentUsername()
                DispatchQueue.main.async {
                    self.username.text = username ?? ""
                }
            } catch {
                DispatchQueue.main.async {
                    print("Username Error: Failed to load username")
                }
            }
        }
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData() {
        myGroupsCountLabel.text = String(groupList.count)
        // TODO: a bit slow loading time, but not sure how to fix it yet
        // TODO: Habits and Days are static right now
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        
        settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
        
        profileImageView.tintColor = colorMainPrimary
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.borderColor = colorMainText.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = ProfileView.profileImageViewHeight / 2
        profileImageView.clipsToBounds = true
        
        myHabitsCountLabel.setBoldText(status: true)
        myGroupsCountLabel.setBoldText(status: true)
        myDaysCountLabel.setBoldText(status: true)
        
        myHabitsLabel.changeFontSize(fontSize: 16)
        myGroupsLabel.changeFontSize(fontSize: 16)
        myDaysLabel.changeFontSize(fontSize: 16)
        
        userInfoStackView = UIStackView(arrangedSubviews: [profileImageView, username])
        userInfoStackView.axis = .horizontal
        userInfoStackView.alignment = .center
        userInfoStackView.spacing = 1
        
        habitsStackView = UIStackView(arrangedSubviews: [myHabitsCountLabel, myHabitsLabel])
        habitsStackView.axis = .vertical
        habitsStackView.alignment = .center
        habitsStackView.distribution = .equalSpacing
        
        groupsStackView = UIStackView(arrangedSubviews: [myGroupsCountLabel, myGroupsLabel])
        groupsStackView.axis = .vertical
        groupsStackView.alignment = .center
        groupsStackView.distribution = .equalSpacing
        
        daysStackView = UIStackView(arrangedSubviews: [myDaysCountLabel, myDaysLabel])
        daysStackView.axis = .vertical
        daysStackView.alignment = .center
        daysStackView.distribution = .equalSpacing
        
        statsStackView = UIStackView(arrangedSubviews: [userInfoStackView, habitsStackView, groupsStackView, daysStackView])
        statsStackView.axis = .horizontal
        statsStackView.alignment = .center
        statsStackView.spacing = 2
        statsStackView.distribution = .fillProportionally
        
        groupsLabel.setBoldText(status: true)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        groupsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(statsStackView)
        addSubview(groupsLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: ProfileView.profileImageViewHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: ProfileView.profileImageViewHeight),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            statsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            groupsLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 10),
            groupsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            tableView.topAnchor.constraint(equalTo: groupsLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc func handleSettingsButton() {
        delegate?.didTouchSettingsButton()
    }
}
