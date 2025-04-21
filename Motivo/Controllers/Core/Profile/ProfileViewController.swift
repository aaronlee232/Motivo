//
//  ProfileViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewDelegate, GroupTableViewDelegate {
    
    // MARK: - UI Elements
    private var profileView = ProfileView()
    
    // MARK: - Properties
    private let isViewingOtherUser: Bool
    private var userUID: String
    
    private let profileManager = ProfileManager()
    private var username: String!
    private var groupMetadataList: [GroupMetadata] = []
    private var habits: [HabitModel] = []
    private var habitsWithImages: [HabitPhotoData] = []
    
    // MARK: - Initializers
    convenience init() {
        self.init(isViewingOtherUser: false)
    }

    init(isViewingOtherUser: Bool, userUID: String? = nil) {
        self.isViewingOtherUser = isViewingOtherUser
        
        if isViewingOtherUser {
            guard let uid = userUID else {
                fatalError("userUID must be provided when viewing another user's profile")
            }
            self.userUID = uid
        } else if let user = AuthManager.shared.getCurrentUserAuthInstance() {
            self.userUID = user.uid
        } else {
            self.userUID = "unknown_user"
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupProfileView()
        setupMenuButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await loadProfileData()
        }
    }
}

// MARK: - UI Setup
extension ProfileViewController {
    private func setupProfileView() {
        view.addSubview(profileView)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // TODO: Why do we need this? Is it possible to move into profile view?
    private func setupMenuButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileView.headerView.settingsButton)
    }
}

// MARK: - Actions
extension ProfileViewController {
    func didTouchSettingsButton() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func didSelectGroupCell(groupIdx: Int) {
        // Read only cells when viewing other users
        if isViewingOtherUser {
            return
        }
        
        let groupVC = GroupViewController(groupID: groupMetadataList[groupIdx].groupID)
        navigationController?.pushViewController(groupVC, animated: true)
    }
}

// MARK: - Data Fetching
extension ProfileViewController {
    private func loadProfileData() async {
        do {
            async let usernameTask = profileManager.fetchCurrentUsername(forUserUID: userUID)
            async let habitsTask = profileManager.fetchHabits(forUserUID: userUID)
            async let groupsTask = profileManager.fetchGroupMetadataList(forUserUID: userUID)
            async let galleryTask = profileManager.fetchHabitsWithVerifiedImageURLs(forUserUID: userUID)

            // Await results
            let (fetchedUsername, fetchedHabits, fetchedGroups, fetchedGallery) = try await (
                usernameTask, habitsTask, groupsTask, galleryTask
            )

            // Assign values
            username = fetchedUsername
            habits = fetchedHabits
            groupMetadataList = fetchedGroups
            habitsWithImages = fetchedGallery

            // Select habits with images to display
            habitsWithImages = habitsWithImages.filter { !$0.imageURLs.isEmpty }
            
            // Configure the view
            profileView.configure(
                delegate: self,
                withUsername: username,
                withHabits: habits,
                withGroupMetadataList: groupMetadataList,
                withHabitsWithImages: habitsWithImages
            )

        } catch {
            AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to load profile data")
            print("Error: \(error.localizedDescription)")
        }
    }
}
