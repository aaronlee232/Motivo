import FirebaseFirestore

protocol HabitViewDelegate:HabitViewController {
    func didSwipeToDeleteHabitCell(withHabitWithRecord: HabitWithRecord, atSection section: Int)
}

class HabitView: UIView {
    
    // MARK: UI Elements
    private let tableView = UITableView()
    private let titleLabel = BoldTitleLabel(textLabel: "Habits")
    
    // MARK: Properties
    private let habitManager = HabitManager()
    private var categoryIDToName: Dictionary<String, String> = Dictionary()
    private var habitWithRecordList: [HabitWithRecord] = []
    private var openedSections: Set<Int> = Set()
    
    private var cameraDelegate: HabitCellViewCameraDelegate!
    private var habitViewDelegate: HabitViewDelegate!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func configure(
        withHabitViewDelegate habitViewDelegate: HabitViewDelegate,
        withCameraDelegate cameraDelegate: HabitCellViewCameraDelegate,
        withCategories categories: [CategoryModel],
        withHabitWithRecordList habitWithRecordList: [HabitWithRecord]
    ) {
        // Set delegates
        self.habitViewDelegate = habitViewDelegate
        self.cameraDelegate = cameraDelegate
        tableView.delegate = self
        tableView.dataSource = self

        // Configure with values
        self.categoryIDToName = Dictionary(uniqueKeysWithValues: categories.map{ ($0.id, $0.name ) })
        self.habitWithRecordList = habitWithRecordList
        
        // Sort habits to keep completed habits at the bottom
        self.habitWithRecordList.sort {
            return !$0.isCompleted && $1.isCompleted
        }

        // Reload table with new data
        tableView.reloadData()
    }
    
    func removeItem(atIndexPathSection section: Int) {
        self.habitWithRecordList.remove(at: section)
        tableView.reloadData()
    }
}

// MARK: - UI Setup
extension HabitView {
    private func setupUI() {
        titleLabel.textAlignment = .center
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitMainCell.self, forCellReuseIdentifier: HabitMainCell.identifier)
        tableView.register(HabitExpandableCell.self, forCellReuseIdentifier: HabitExpandableCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

        addSubview(titleLabel)
        addSubview(tableView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}


// MARK: - Table delegate methods
extension HabitView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Collapse expanded sections when starting to swipe
        if openedSections.contains(indexPath.section) {
            openedSections.remove(indexPath.section)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        
        let habitWithRecord = habitWithRecordList[indexPath.section]
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete") { (action, view, success) in
            // Open alert
            self.habitViewDelegate.didSwipeToDeleteHabitCell(
            withHabitWithRecord: habitWithRecord,
            atSection: indexPath.section
            )   
        }
        deleteAction.backgroundColor = .white.withAlphaComponent(0)
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Main View Cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitMainCell.identifier, for: indexPath) as? HabitMainCell else {
                return UITableViewCell()
            }
            
            let habitWithRecord = habitWithRecordList[indexPath.section]
            cell.configure(
                cameraDelegate: cameraDelegate,
                expandDelegate: self,
                withHabitWithRecord: habitWithRecord,
                categoryIDToName: categoryIDToName,
                isExpanded: openedSections.contains(indexPath.section)
            )
            return cell
        } else {
            // Expanded habit cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitExpandableCell.identifier, for: indexPath) as? HabitExpandableCell else {
                return UITableViewCell()
            }
            
            let habitWithRecord = habitWithRecordList[indexPath.section]
            cell.configure(withHabitWithRecord: habitWithRecord)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12 // Adjust the space between sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return habitWithRecordList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections.contains(section) {
            // Main Cell View + Expanded Cell View
            return 2
        } else {
            // Main Cell View
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Expand Habit Cell
extension HabitView: HabitCellViewExpansionDelegate {
    func onCellExpandButtonTapped(selectedHabitID: String) {
        // Find clicked index based on habit id
        var sectionIndex: Int!
        for (index, habitWithRecord) in habitWithRecordList.enumerated() {
            if (habitWithRecord.habit.id == selectedHabitID) {
                sectionIndex = index
            }
        }
        
        // Toggle open status of cell at clicked index
        if (openedSections.contains(sectionIndex)) {
            openedSections.remove(sectionIndex)
        } else {
            openedSections.insert(sectionIndex)
        }
        
        tableView.reloadData()
    }
}
