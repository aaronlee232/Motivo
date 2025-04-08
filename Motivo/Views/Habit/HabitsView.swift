import FirebaseFirestore

class HabitsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private let habitManager = HabitManager()
    private let tableView = UITableView()
    
    var categoryIDToName: [String:String] = [:]
    var categories: [CategoryModel] = [] {
        didSet {
            categoryIDToName = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0.name) })
            tableView.reloadData()
        }
    }

    var habits: [HabitModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var habitRecords: [String: HabitRecord] = [:] // Map habit ID to its record
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        tableView.tableFooterView = UIView()

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func sortHabits() {
        // Keep completed habits at the bottom
        habits.sort { (habit1, habit2) in
            let completed1 = habitRecords[habit1.id]?.isCompleted ?? false
            let completed2 = habitRecords[habit2.id]?.isCompleted ?? false
            return !completed1 && completed2
        }
    }

    func habitRecord(for habitID: String) -> HabitRecord? {
        return habitRecords[habitID]
    }

//    func updateHabitRecord(for habitID: String) {
//        guard var record = habitRecords[habitID] else { return }
////        record.completedCount += 1
//        // TODO: Check this commented out
//
//        // Update Firestore
//        Task {
//            do {
//                habitManager.increaseHabitRecordCompletedCount(withHabitRecordID: record.id)
//            } catch {
//                
//            }
//        }
//
//        habitRecords[habitID] = record
//        sortHabits()
//    }
}

extension HabitsView {
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as! HabitCell
        let habit = habits[indexPath.row]
        let record = habitRecord(for: habit.id)
        
        // Will be initially empty until categories is loaded
        let categoryNames = habits[indexPath.row].categoryIDs.compactMap { categoryID in categoryIDToName[categoryID] }

        let completedCount = record?.completedCount ?? 0
        let unit = habit.unit.isEmpty ? "" : " \(habit.unit)" // Ensure unit is used properly
        let progressText: String

        switch habit.frequency {
        case "Daily":
            progressText = "\(completedCount) / \(habit.goal)\(unit) Today"
        case "Weekly":
            progressText = "\(completedCount) / \(habit.goal)\(unit) This Week"
        case "Monthly":
            progressText = "\(completedCount) / \(habit.goal)\(unit) This Month"
        default:
            progressText = "\(completedCount) / \(habit.goal)\(unit)"
        }

        cell.configureWith(habit: habit, progressText: progressText, categoryNames: categoryNames)
//        cell.onPlusTapped = { [weak self] in
//            updateHabitRecord(for: habit.id)
//            tableView.reloadData()
//        }

        return cell
    }
}
