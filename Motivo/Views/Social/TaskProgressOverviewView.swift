//
//  ProgressOverview.swift
//  Motivo
//
//  Created by Aaron Lee on 3/28/25.
//

import UIKit

// TODO: Replace with real task model
struct DummyTask {
    var name: String
    var taskStatus: TaskStatus
    
    init(name: String, taskStatus: TaskStatus) {
        self.name = name
        self.taskStatus = taskStatus
    }
}

class TaskProgressOverviewView: UIView {
    
    // MARK: - UI Elements
    let mainStackView = UIStackView() // horizontal container stack
    let profileImageView = UIImageView()
    let contentStackView = UIStackView()
    let expandButton = UIButton()
    let taskPreviewTableView = UITableView()
    
    let nudgeStackView = UIStackView()
    let nameLabel = UILabel()
    let nudgeLabel = UILabel()
    let nudgeButton = UIButton()
    let progressBarView = UIProgressView(progressViewStyle: .default)
    let spacerView = UIView()
    
    // MARK: - Properties
    private var isExpanded = false
    private var taskTableHeightConstraint: NSLayoutConstraint?
    var taskList: [DummyTask] = [] {
        didSet {
            taskPreviewTableView.reloadData()
            updateProgressBar()
        }
    }
    
    // MARK: - Initializers
    convenience init(name: String, profileImage: UIImage?) {
        self.init(frame: .zero)
        configureWith(name: name, profileImage: profileImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureTableView()
        configureDefaultValues()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension TaskProgressOverviewView {
    private func setupUI() {
        setupMainStackView()
        setupNudgeStackView()
        setupTaskPreviewTableView()
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            taskPreviewTableView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 12),
            taskPreviewTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            taskPreviewTableView.leadingAnchor.constraint(equalTo: progressBarView.leadingAnchor),
            taskPreviewTableView.trailingAnchor.constraint(equalTo: progressBarView.trailingAnchor)
        ])
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(profileImageView)
        mainStackView.addArrangedSubview(contentStackView)
        mainStackView.addArrangedSubview(expandButton)
        profileImageView.contentMode = .scaleAspectFit
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentStackView.addArrangedSubview(nudgeStackView)
        contentStackView.addArrangedSubview(progressBarView)
    }
    
    private func setupNudgeStackView() {
        nudgeStackView.axis = .horizontal
        nudgeStackView.spacing = 10
        nudgeStackView.addArrangedSubview(nameLabel)
        nudgeStackView.addArrangedSubview(spacerView)
        nudgeStackView.addArrangedSubview(nudgeLabel)
        nudgeStackView.addArrangedSubview(nudgeButton)
        
        // Allow spacerView to take up extra space so other elements are pushed to edges
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupTaskPreviewTableView() {
        taskPreviewTableView.translatesAutoresizingMaskIntoConstraints = false
        taskTableHeightConstraint = taskPreviewTableView.heightAnchor.constraint(equalToConstant: 0)
        taskTableHeightConstraint?.isActive = true
        addSubview(taskPreviewTableView)
    }
}

// MARK: - Configuration
extension TaskProgressOverviewView {
    private func configureWith(name: String, profileImage: UIImage?) {
        self.nameLabel.text = name
        self.profileImageView.image = profileImage ?? UIImage(systemName: "person.crop.circle")
    }
    
    private func configureDefaultValues() {
        nudgeLabel.text = "Give em a nudge!"
        nudgeButton.setImage(UIImage(systemName: "megaphone.fill"), for: .normal)
        expandButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        expandButton.addTarget(self, action: #selector(toggleTaskPreview), for: .touchUpInside)
    }
}


// MARK: - UITableView Setup
extension TaskProgressOverviewView: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        taskPreviewTableView.register(TaskPreviewCell.self, forCellReuseIdentifier: TaskPreviewCell.reuseIdentifier)
        taskPreviewTableView.delegate = self
        taskPreviewTableView.dataSource = self
        taskPreviewTableView.rowHeight = UITableView.automaticDimension;
        taskPreviewTableView.estimatedRowHeight = 44.0;
        taskPreviewTableView.separatorStyle = .none
        taskPreviewTableView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskPreviewTableView.dequeueReusableCell(withIdentifier: TaskPreviewCell.reuseIdentifier, for: indexPath) as? TaskPreviewCell else {
            return UITableViewCell()
        }
        
        let task = taskList[indexPath.row]
        cell.configureWith(taskStatus: task.taskStatus, taskName: task.name)
        
        return cell
    }
}


// MARK: - Actions
extension TaskProgressOverviewView {
    @objc private func toggleTaskPreview() {
        isExpanded.toggle()
        
        // Force the table view to calculate its content size
        taskPreviewTableView.layoutIfNeeded()
        let targetHeight = isExpanded ? taskPreviewTableView.contentSize.height : 0
        self.taskTableHeightConstraint?.constant = targetHeight
        
        // Expand or collapse
        let chevronIcon = self.isExpanded ? "chevron.down" : "chevron.left"
        self.expandButton.setImage(UIImage(systemName: chevronIcon), for: .normal)
        
        self.layoutIfNeeded()
    }
}


// MARK: - ProgressBar
extension TaskProgressOverviewView {
    func updateProgressBar() {
        let totalTasks = taskList.count
        let completedTasks = taskList.filter { $0.taskStatus == .complete }.count
        
        // Avoid division by zero
        let progress = totalTasks > 0 ? Float(completedTasks) / Float(totalTasks) : 0.0
        
        progressBarView.setProgress(progress, animated: false)
    }
}
