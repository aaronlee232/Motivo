import UIKit

class HabitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let habitsView = HabitsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Habits"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habitsView.loadHabits()

        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .didUpdateHabitRecords, object: nil)
    }

    @objc private func updateTableView() {
        tableView.reloadData()
    }


    @objc private func addHabit() {
        // Navigate to Add Habit page
        let addHabitVC = AddHabitViewController()
        navigationController?.pushViewController(addHabitVC, animated: true)
    }

    @objc private func openSettings() {
        // Navigate to Settings page
        let settingsVC = HabitSettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitsView.numberOfHabits()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as! HabitCell
        let habit = habitsView.habit(at: indexPath.row)
        let record = habitsView.habitRecord(for: habit.id)

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

        cell.configure(with: habit, progressText: progressText)
        cell.onPlusTapped = { [weak self] in
            self?.habitsView.updateHabitRecord(for: habit.id)
            self?.tableView.reloadData()
        }

        return cell
    }


}
