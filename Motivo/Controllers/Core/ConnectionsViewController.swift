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
        
        loadConnections()
        configureScreen()
        setupConstraints()
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
                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
                    print("Error: No authenticated user.")
                    return
                }
                
                guard let user: UserModel = try await connectionsManager.fetchUser(uid: userAuthInstance.uid) else {
                    print("Error: Failed to fetch user.")
                    return
                }
                
                let connections: [UserModel] = try await connectionsManager.fetchConnections(for: user.uid)
                self.sections = organizeUsers(connections, favorites: user.favoriteUsers)
                self.tableView.reloadData()
            } catch {
                print("Error loading connections: \(error.localizedDescription)")
            }
        }
        
    }
    
    private func organizeUsers(_ users: [UserModel], favorites: [String]) -> [UserSection] {
        let favoritesSet: Set<String> = Set(favorites)
        var groupedUsers: [String: [UserModel]] = [:]
        var favoritesSectionList: [UserModel] = []

        for user in users {
            if favoritesSet.contains(user.username) {
                favoritesSectionList.append(user)
            } else {
                let firstLetter = String(user.username.prefix(1)).uppercased()
                groupedUsers[firstLetter, default: []].append(user)
            }
        }

        let sortedSections = groupedUsers.keys.sorted()
        var sections: [UserSection] = []

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
        //TODO: Implement
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
            break
        default:
            print("Missing handler for pressed Header Button. Add case implementation in didTapHeaderButton")
        }
    }

}


