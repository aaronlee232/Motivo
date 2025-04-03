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
    
    private let groupOverviewView = GroupOverviewView()
    private let groupProgressView = GroupProgressView()
    private let segmentedControl = UISegmentedControl()
    
    private var groupID: String!
    private var currentScreen: GroupScreenType {
        didSet {
            switchScreen(screen: currentScreen)
        }
    }
    
    init(groupID: String) {
        self.groupID = groupID
        currentScreen = GroupScreenType.overview
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupTitleBar()
        setupSegmentedControl()
        setupViews()
        
        // Manually switch screen
        switchScreen(screen: currentScreen)
    }
    
    private func setupTitleBar() {
        self.title = "Group Name (\(groupID!))"
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
    
    private func setupViews() {
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
        
    }
    
    @objc private func didTapInviteUserButton() {
        
    }
    
    @objc private func didTapLeaveGroupButton() {
        
    }
    
}

