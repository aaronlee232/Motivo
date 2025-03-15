//
//  PeopleViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

// MARK: - ConnectionsViewController (Main Class)
class ConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HeaderViewDelegate {

    // MARK: - Properties
    private let connectionsManager = ConnectionsManager()
    
    private let headerView = HeaderView()
    private let tableView = UITableView()
    private var sections: [UserSection] = []
    private var buttonIndexMapping: [UIButton: IndexPath] = [:]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        configureScreen()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadConnections()
    }
    
    // MARK: - UI Setup
    private func configureScreen() {
        // Set up Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.frame = tableView.bounds
        view.addSubview(tableView)
        
        // Set up Header View
        headerView.delegate = self
        headerView.titleLabel.text = "Connections"
        view.addSubview(headerView)
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Header Constraints
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Table Constraints
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Handling
    // Retrieve the current user's connections and organize them into table UserSections
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
                let connections: [UserModel] = try await connectionsManager.fetchConnections(for: user.uid)
                self.sections = organizeUsers(connections, favoriteUids: user.favoriteUsers)
                self.tableView.reloadData()
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "We couldn't retrieve your connections.")
                print("Error loading connections: \(error.localizedDescription)")
            }
        }
        
    }
    
    // Organize a list of users into sections alphabetically and separate "favorite" users into their own section.
    private func organizeUsers(_ users: [UserModel], favoriteUids: [String]) -> [UserSection] {
        let favoritesSet: Set<String> = Set(favoriteUids)
        var groupedUsers: [String: [UserModel]] = [:]
        var favoritesSectionList: [UserModel] = []

        // Divide users into "favorites" and "grouped users"
        for user in users {
            if favoritesSet.contains(user.uid) {
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
        
        print("Tapped on \(user.username)'s counter button")

        // TODO: Add segue to camera for photo proof of completion
    }
    
    // TODO: Add an action to the UserCell so that tapping on it will bring the current user to a profile screen of the tapped user
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = sections[indexPath.section].users[indexPath.row]

        cell.configure(with: user)
        buttonIndexMapping[cell.counterButton] = indexPath
        cell.counterButton.addTarget(self, action: #selector(counterTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    // MARK: - HeaderViewDelegate
    // Implement delegate methods for the HeaderView Buttons
    func didTapHeaderButton(_ button: HeaderButtonType) {
        switch button {
        case .menu:
            // TODO: Add dropdown menu for "Hide People", "View Hidden"
            print("Menu Tapped")
            break
        }
    }

}


