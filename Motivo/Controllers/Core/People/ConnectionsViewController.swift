//
//  PeopleViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

struct VotedPhoto: Hashable {
    let habitRecordID: String
    let photoURL: String
}

// MARK: - ConnectionsViewController (Main Class)
class ConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private var sections: [UserSection] = []
    private var buttonIndexMapping: [UIButton: IndexPath] = [:]
    private let titleLabel = BoldTitleLabel(textLabel: "Connections")
    
    // MARK: - Properties
    private let connectionsManager = ConnectionsManager()
    private var activeHabitWithRecordsByUserUID = Dictionary<String, [HabitWithRecord]>()
    private var votedPhotoSet: Set<VotedPhoto> = Set()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureScreen()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadVotes()
        loadConnections()
    }
    
    // MARK: - UI Setup
    private func configureScreen() {
        // Set up Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.frame = tableView.bounds
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        
        // Set up Header View
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Table Constraints
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Handling
    // Retrieve the current user's connections and organize them into table UserSections
    func loadVotes() {
        Task {
            do {
                // Retrieve logged in user's auth instance
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    print("Error: No authenticated user.")
                    return
                }
                
                let votes = try await connectionsManager.fetchVotes(forUserUID: userAuthInstance.uid)
                votedPhotoSet = Set(votes.map { VotedPhoto(habitRecordID: $0.habitRecordID, photoURL: $0.photoURL) })
                tableView.reloadData()
            }
        }
    }
    
    func loadConnections() {
        Task {
            do {
                // Retrieve logged in user's auth instance
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    print("Error: No authenticated user.")
                    return
                }
                
                // Use logged in user's uid to find their UserModel in FireStore
                guard let user: UserModel = try await connectionsManager.fetchUser(uid: userAuthInstance.uid) else {
                    print("Error: Failed to fetch user.")
                    return
                }
                
                // Fetch the list of connected UserModels that are connected to the user through a group
                let connections: [UserModel] = try await connectionsManager.fetchConnections(for: user.id)
                
                // Fetch active habit records for each user
                for user in connections {
                    let activeHabitWithRecords = try await connectionsManager.fetchActiveHabitWithRecords(forUserUID: user.id)
                    activeHabitWithRecordsByUserUID[user.id] = activeHabitWithRecords
                }
                
                self.sections = organizeUsers(connections, favoriteUIDs: user.favoriteUsers)
                self.tableView.reloadData()
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "We couldn't retrieve your connections.")
                print("Error loading connections: \(error.localizedDescription)")
            }
        }
        
    }
    
    // Organize a list of users into sections alphabetically and separate "favorite" users into their own section.
    private func organizeUsers(_ users: [UserModel], favoriteUIDs: [String]) -> [UserSection] {
        let favoritesSet: Set<String> = Set(favoriteUIDs)
        var groupedUsers: [String: [UserModel]] = [:]
        var favoritesSectionList: [UserModel] = []

        // Divide users into "favorites" and "grouped users"
        for user in users {
            if favoritesSet.contains(user.id) {
                favoritesSectionList.append(user)
            } else {
                let firstLetter = String(user.username.prefix(1)).uppercased()
                groupedUsers[firstLetter, default: []].append(user)
            }
        }
        // Sort grouped sections alphabetically based on username
        let sortedSections = groupedUsers.keys.sorted()
        
        // Instatiate sections to be empty
        var sections: [UserSection] = []
        
        // Populate sections with Favorites and alphabetically sorted user groups
        if !favoritesSectionList.isEmpty {
            sections.append(UserSection(sectionTitle: "Favorites", users: favoritesSectionList))
        }
        for key in sortedSections {
            sections.append(UserSection(sectionTitle: key, users: groupedUsers[key]!))
        }

        return sections
    }

    
    // MARK: - Actions
    @objc func counterTapped(_ sender: UIButton) {
        guard let indexPath = buttonIndexMapping[sender] else { return }
        let user = sections[indexPath.section].users[indexPath.row]

        // Navigate to Settings page
        let verificationVC = VerificationViewController()
        verificationVC.configureWith(
            user: user,
            habitWithRecordsByUserUID: activeHabitWithRecordsByUserUID,
            votedPhotoSet: votedPhotoSet
        )
        
        navigationController?.pushViewController(verificationVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        let user = sections[indexPath.section].users[indexPath.row]

        cell.configure(
            withUser: user,
            withHabitWithRecords: activeHabitWithRecordsByUserUID[user.id] ?? [],
            withVotedPhotoSet: votedPhotoSet
        )
        buttonIndexMapping[cell.counterButton] = indexPath
        cell.counterButton.addTarget(self, action: #selector(counterTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to other user's profile
        let user = sections[indexPath.section].users[indexPath.row]
        let profileVC = ProfileViewController(isViewingOtherUser: true, userUID: user.id)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}


