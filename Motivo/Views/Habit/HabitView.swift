import FirebaseFirestore

protocol HabitViewDelegate: HabitViewController {
    func plusButtonTapped(on habitWithRecord: HabitWithRecord)
}

class HabitView: UIView {
    
    // MARK: UI Elements
    private let tableView = UITableView()
    private let titleLabel = BoldTitleLabel(textLabel: "Habits")
    
    // MARK: Properties
    private let habitManager = HabitManager()
    private var categoryIDToName: Dictionary<String, String> = Dictionary()
    private var habitWithRecordList: [HabitWithRecord] = []
    
    var delegate: HabitViewDelegate?
    
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
        tableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        tableView.tableFooterView = UIView()

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


// MARK: - UITableView DataSource
extension HabitView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitWithRecordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Redo cell to be more informative
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as? HabitCell else {
            return UITableViewCell()
        }
        
        let habitWithRecord = habitWithRecordList[indexPath.row]
        let habit = habitWithRecord.habit
        let record = habitWithRecord.record
        
        let categoryNames = habit.categoryIDs.compactMap { categoryIDToName[$0] }
        let unit = habit.unit.isEmpty ? "" : " \(habit.unit)"
        
        let pendingPart = record.pendingCount > 0 ? " + (\(record.pendingCount))" : ""
        let progressText: String

        switch habit.frequency {
        case "Daily":
            progressText = "\(record.completedCount)\(pendingPart) / \(habit.goal)\(unit) Today"
        case "Weekly":
            progressText = "\(record.completedCount)\(pendingPart) / \(habit.goal)\(unit) This Week"
        case "Monthly":
            progressText = "\(record.completedCount)\(pendingPart) / \(habit.goal)\(unit) This Month"
        default:
            progressText = "\(record.completedCount)\(pendingPart) / \(habit.goal)\(unit)"
        }

        cell.configureWith(habit: habit, progressText: progressText, categoryNames: categoryNames)

        cell.onPlusTapped = { [weak delegate] in
            delegate?.plusButtonTapped(on: habitWithRecord)
        }

        return cell
    }

}
