import FirebaseFirestore

class HabitView: UIView {
    
    // MARK: UI Elements
    private let tableView = UITableView()
    private let titleLabel = BoldTitleLabel(textLabel: "Habits")
    
    // MARK: Properties
    private let habitManager = HabitManager()
    private var categoryIDToName: Dictionary<String, String> = Dictionary()
    private var habitWithRecordList: [HabitWithRecord] = []
    private var openedSections: Set<Int> = Set()
    
    var delegate: HabitCellViewCameraDelegate!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func configure(
        withCategories categories: [CategoryModel],
        withHabitWithRecordList habitWithRecordList: [HabitWithRecord]
    ) {
        // Set delegates
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Main View Cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitMainCell.identifier, for: indexPath) as? HabitMainCell else {
                return UITableViewCell()
            }
            
            let habitWithRecord = habitWithRecordList[indexPath.section]
            cell.configure(
                cameraDelegate: delegate,
                expandDelegate: self,
                withHabitWithRecord: habitWithRecord,
                withRejectVotes: [],
                isExpanded: openedSections.contains(indexPath.section)
            )

            return cell
        } else {
            // Expanded habit cells
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitExpandableCell.identifier, for: indexPath) as? HabitExpandableCell else {
                return UITableViewCell()
            }
            
            let habitWithRecord = habitWithRecordList[indexPath.section]
            cell.configure(
                withHabitWithRecord: habitWithRecord,
                withRejectVotes: []
            )

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
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 30
//    }
}

// MARK: -
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
