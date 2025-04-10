import FirebaseFirestore

protocol HabitViewDelegate: HabitViewController {
    func plusButtonTapped(with habit: HabitModel)
}

class HabitsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UI Elements
    private let tableView = UITableView()
    private let titleLabel = BoldTitleLabel(textLabel: "Habits")
    
    // MARK: Properties
    private let habitManager = HabitManager()
    var categoryIDToName: [String:String] = [:]
    var categories: [CategoryModel] = [] {
        didSet {
            categoryIDToName = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0.name) })
            tableView.reloadData()
        }
    }
    private var habitRecords: [String: HabitRecord] = [:] // Map habit ID to its record
    var habits: [HabitModel] = [] {
        didSet {
            tableView.reloadData()
            loadHabitRecords()
        }
    }
    
    // Added this here to properly load the records in, it was failing earlier - Feel free to move in a refactor
    func loadHabitRecords() {
        Task {
            var newHabitRecords: [String: HabitRecord] = [:]

            for habit in habits {
                do {
                    let records = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)
                    if let record = records.first {
                        newHabitRecords[habit.id] = record
                    }
                } catch {
//                    print("Failed to fetch habit record for \(habit.id): \(error)")
                }
            }

            // Update UI on the main thread
            DispatchQueue.main.async {
                self.habitRecords = newHabitRecords
                self.sortHabits()
                self.tableView.reloadData()
            }
        }
    }

    
    var delegate: HabitViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
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

        let categoryNames = habit.categoryIDs.compactMap { categoryIDToName[$0] }
        
        let numCompleted = record?.completedCount ?? 0
        let numPending = record?.pendingCount ?? 0
        let unit = habit.unit.isEmpty ? "" : " \(habit.unit)"
        
        let pendingPart = numPending > 0 ? " + (\(numPending))" : ""
        let progressText: String

        switch habit.frequency {
        case "Daily":
            progressText = "\(numCompleted)\(pendingPart) / \(habit.goal)\(unit) Today"
        case "Weekly":
            progressText = "\(numCompleted)\(pendingPart) / \(habit.goal)\(unit) This Week"
        case "Monthly":
            progressText = "\(numCompleted)\(pendingPart) / \(habit.goal)\(unit) This Month"
        default:
            progressText = "\(numCompleted)\(pendingPart) / \(habit.goal)\(unit)"
        }

        cell.configureWith(habit: habit, progressText: progressText, categoryNames: categoryNames)

        cell.onPlusTapped = { [weak delegate] in
            delegate?.plusButtonTapped(with: habit)
        }

        return cell
    }

}
