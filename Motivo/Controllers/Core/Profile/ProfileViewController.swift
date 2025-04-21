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
    private let profileManager = ProfileManager()
    private var username: String!
    private var groupMetadataList: [GroupMetadata] = []
    private var habits: [HabitModel] = []
    private var habitsWithImages: [HabitPhotoData] = []
    
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
        let groupVC = GroupViewController(groupID: groupMetadataList[groupIdx].groupID)
        navigationController?.pushViewController(groupVC, animated: true)
    }
}

// MARK: - Data Fetching
extension ProfileViewController {
    private func loadProfileData() async {
        do {
            guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                return
            }
            
            async let usernameTask = profileManager.fetchCurrentUsername(forUserUID: user.uid)
            async let habitsTask = profileManager.fetchHabits(forUserUID: user.uid)
            async let groupsTask = profileManager.fetchGroupMetadataList(forUserUID: user.uid)
            async let galleryTask = profileManager.fetchHabitsWithVerifiedImageURLs(forUserUID: user.uid)

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
