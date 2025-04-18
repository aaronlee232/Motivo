//
//  GroupViewController.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/1/25.
//

import UIKit

class GroupViewController: UIViewController {
    private enum GroupScreenType: Int {
        case overview = 0
        case progress = 1
    }
    
    // MARK: - UI Elements
    private let groupOverviewView = GroupOverviewView()
    private let groupProgressView = GroupProgressView()
    private let segmentedControl = UISegmentedControl()
    
    // MARK: - Properties
    private let groupManager = GroupManager()
    private var groupID: String!
    private var currentScreen: GroupScreenType {
        didSet {
            switchScreen(screen: currentScreen)
        }
    }
    
    // MARK: - Initializers
    init(groupID: String) {
        self.groupID = groupID
        currentScreen = GroupScreenType.overview
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        fetchAndSetGroupName()
        fetchAndSetGroupMemberHabitsAndUsers()
        fetchAndSetCategories()
        fetchAndSetProgressCells()
        
        setupTitleBar()
        setupSegmentedControl()
        setupTabViews()
        
        // Manually switch screen
        switchScreen(screen: currentScreen)
    }
}

// MARK: - Data Fetching
extension GroupViewController {
    private func fetchAndSetGroupName() {
        Task {
            do {
                self.title = try await groupManager.fetchGroupName(groupID: groupID)
            } catch {
                print("Error loading group name: \(error.localizedDescription)")
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "The group name couldn't be retrieved")
            }
        }
    }
    
    private func fetchAndSetProgressCells() {
        Task {
            do {
                let rawProgressCells = try await groupManager.fetchProgressCells(forGroupID: groupID)
                let filteredProgressCells = rawProgressCells.filter { $0.habitEntries.count > 0 }
                groupProgressView.progressCells = filteredProgressCells
            } catch {
                print("Error loading group progress cells: \(error.localizedDescription)")
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Group member progress couldn't be retrieved.")
            }
        }
    }
    
    private func fetchAndSetCategories() {
        Task {
            do {
                let categories = try await groupManager.fetchCategories(forGroupID: groupID)
                groupOverviewView.categories = categories
            } catch {
                print("Error fetching group categories: \(error.localizedDescription)")
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Group categories couldn't be retrieved.")
            }
        }
    }
    
    private func fetchAndSetGroupMemberHabitsAndUsers() {
        Task {
            do {
                let categories = try await groupManager.fetchCategories(forGroupID: groupID)
                let users = try await groupManager.fetchGroupUsers(forGroupID: groupID)
                let usersByUID = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
                let memberHabits = try await groupManager.fetchUserHabits(
                    forUserUID: users.map {$0.id},
                    withCategoryIDs: categories.map{ $0.id }
                )
                
                let userHabitPairs = memberHabits.map { ($0, usersByUID[$0.userUID]! ) }

                groupOverviewView.categories = categories
                groupOverviewView.userHabitPairs = userHabitPairs
            } catch {
                print("Error fetching group categories: \(error.localizedDescription)")
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Group member habits couldn't be retrieved.")
            }
        }
    }
}

// MARK: - UI Setup
extension GroupViewController {
    private func setupTitleBar() {
        self.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Edit Group Name", image: UIImage(systemName: "pencil"), handler: { _ in
                self.didTapEditGroupNameButton()
            }),
            UIAction(title: "Invite User", image: UIImage(systemName: "person.fill.badge.plus"), handler: { _ in
                self.didTapInviteUserButton()
            }),
            UIAction(title: "Leave Group", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), attributes: .destructive, handler: { _ in
                self.didTapLeaveGroupButton()
            })
        ])
        
        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: menu
        )
        
        navigationItem.rightBarButtonItem = moreButton
    }
    
    private func setupSegmentedControl() {
        // Remove any default segments just in case
        segmentedControl.removeAllSegments()
            
        // Add segments
        let overviewSwitchAction = UIAction(title: "Overview", handler: { _ in self.currentScreen = GroupScreenType.overview })
        let progressSwitchAction = UIAction(title: "Progress", handler: { _ in self.currentScreen = GroupScreenType.progress })
        segmentedControl.insertSegment(action: overviewSwitchAction, at: GroupScreenType.overview.rawValue, animated: false)
        segmentedControl.insertSegment(action: progressSwitchAction, at: GroupScreenType.progress.rawValue, animated: false)
        
        // set default segment
        segmentedControl.selectedSegmentIndex = currentScreen.rawValue
        
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTabViews() {
        view.addSubview(groupOverviewView)
        groupOverviewView.isHidden = true
        groupOverviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupOverviewView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            groupOverviewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            groupOverviewView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            groupOverviewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        view.addSubview(groupProgressView)
        groupProgressView.isHidden = true
        groupProgressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupProgressView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            groupProgressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            groupProgressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            groupProgressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}


// MARK: - Actions
extension GroupViewController {
    private func switchScreen(screen: GroupScreenType) {
        switch screen {
        case GroupScreenType.overview:
            groupOverviewView.isHidden = false
            groupProgressView.isHidden = true
        case GroupScreenType.progress:
            groupOverviewView.isHidden = true
            groupProgressView.isHidden = false
        }
    }
    
    @objc private func didTapEditGroupNameButton() {
        // TODO: Implement edit group segue/view
    }
    
    @objc private func didTapInviteUserButton() {
        // TODO: Implement invite user segue/view
    }
    
    @objc private func didTapLeaveGroupButton() {
        // TODO: Implement leave group confirmation alert and segue
        let controller = UIAlertController(
            title: "Leave Group?",
            message: "Are you sure you want to leave this group?",
            preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "Leave", style: .destructive) {_ in
            Task {
                do {
                    guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                        AlertUtils.shared.showAlert(self, title: "Somthing went wrong", message: "Current user session lost")
                        return
                    }
                            
                    let removedMemberships = try await self.groupManager.removeUserFromGroup(withUserUID: user.uid, withGroupWithID: self.groupID)
                    
                    // Check for possible empty removal
                    if removedMemberships.isEmpty {
                        AlertUtils.shared.showAlert(self, title: "Somthing went wrong", message: "Unable leave group")
                        return
                    }
                    
                    // Return to group screen
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    AlertUtils.shared.showAlert(self, title: "Somthing went wrong", message: "Unable to leave group")
                }
            }
        })
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(controller, animated: true)
    }
}
