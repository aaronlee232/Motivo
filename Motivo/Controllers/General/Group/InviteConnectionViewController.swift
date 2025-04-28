////
////  InviteConnectionViewController.swift
////  Motivo
////
////  Created by Arisyia Wong on 4/25/25.
////
//
//import UIKit
//
//class InviteConnectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
////    private let tableView = UITableView()
////    private var sections:[UserSection] = []
////    private var selectedSections:[UserModel] = []
////    private let cellIdentifier = "InviteConnectionCell"
////    
////    private let titleLabel = BoldTitleLabel(textLabel: "Select People to Add")
////    private let searchButton = IconButton(image: UIImage(systemName: "magnifyingglass")!, barType: true)
////    private let menuButton = IconButton(image: UIImage(systemName: "greaterthan")!, barType: true)
//    
//    private let connectionsManager = ConnectionsManager()
//    private let groupManager = GroupManager()
////    var groupID:String!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        
//        setupUI()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadConnectionsNotInGroup()
//    }
//    
//    private func setupUI() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UserNotInGroupCell.self, forCellReuseIdentifier: UserNotInGroupCell.reuseIdentifier)
//        tableView.frame = tableView.bounds
//        
//        titleLabel.changeFontSize(fontSize: 28)
//        
//        view.addSubview(tableView)
//        view.addSubview(titleLabel)
//        
//        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            // Table Constraints
//            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
//    }
//    
//    // Modified from loadConnections() in ConnectionsVC
//    func loadConnectionsNotInGroup() {
//        Task {
//            do {
//                guard let userAuthInstance = AuthManager.shared.getCurrentUserAuthInstance() else {
//                    print("Error: No authenticated user.")
//                    return
//                }
//                
//                guard let user:UserModel = try await connectionsManager.fetchUser(uid: userAuthInstance.uid) else {
//                    print("Error: Failed to fetch user.")
//                    return
//                }
//                
//                let connections:[UserModel] = try await connectionsManager.fetchConnections(for: user.id)
//                
//                let currentGroupUsers:[UserModel] = try await groupManager.fetchGroupUsers(forGroupID: groupID)
//                
//                // Only get the users that are not already in the group
//                let connectionsNotInCurrentGroup:[UserModel] = connections.filter { connection in !currentGroupUsers.contains(where: { $0.id == connection.id })}
//                
//                self.sections = organizeUsers(connectionsNotInCurrentGroup, favoriteUIDs: user.favoriteUsers)
//            } catch {
//                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "We couldn't retrieve your connections.")
//                print("Error loading in connections: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    private func organizeUsers(_ users:[UserModel], favoriteUIDs:[String]) -> [UserSection] {
//        let favoritesSet: Set<String> = Set(favoriteUIDs)
//        var groupedUsers: [String: [UserModel]] = [:]
//        var favoritesSectionList:[UserModel] = []
//        
//        for user in users {
//            if favoritesSet.contains(user.id) {
//                favoritesSectionList.append(user)
//            } else {
//                let firstLetter = String(user.username.prefix(1)).uppercased()
//                groupedUsers[firstLetter, default: []].append(user)
//            }
//        }
//        
//        let sortedSections = groupedUsers.keys.sorted()
//        
//        var sections:[UserSection] = []
//        
//        if !favoritesSectionList.isEmpty {
//            sections.append(UserSection(sectionTitle: "Favorites", users: favoritesSectionList))
//        }
//        for key in sortedSections {
//            sections.append(UserSection(sectionTitle: key, users: groupedUsers[key]!))
//        }
//        
//        return sections
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].users.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserNotInGroupCell.reuseIdentifier, for: indexPath) as? UserNotInGroupCell else {
//            return UITableViewCell()
//        }
//        
//        let user = sections[indexPath.section].users[indexPath.row]
//        cell.configureWith(username: user.username, isSelected: false)
//        cell.accessoryType = selectedSections.contains(where: { $0.id == user.id }) ? .checkmark : .none
//        return cell
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section].sectionTitle
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = sections[indexPath.section].users[indexPath.row]
//        if selectedSections.contains(where: { $0.id == user.id }) {
//            selectedSections.removeAll { $0.id == user.id } // just in case there is a bug where multiple of the same user is added
//        } else {
//            selectedSections.append(user)
//        }
//        
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        print("in didSelectRowAt: \(selectedSections)")
//    }
//}
