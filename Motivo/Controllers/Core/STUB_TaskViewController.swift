//
//  TaskViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/10/25.
//
import UIKit

// MARK: - Habit Model
struct Habit {
    let name: String
    let isGroupHabit: Bool
    let category: String
    let streak: Int
    let completed: Int
    let goal: Int
    let unit: String
    let frequency: String
}

// MARK: - Sample Data
class HabitData {
    static let habits: [Habit] = [
        Habit(name: "Exercise", isGroupHabit: true, category: "Fitness", streak: 5, completed: 1, goal: 3, unit: "Times", frequency: "Today"),
        Habit(name: "Drink Water", isGroupHabit: false, category: "Health", streak: 7, completed: 2, goal: 3, unit: "Glasses", frequency: "Today"),
        Habit(name: "Hike", isGroupHabit: true, category: "Outdoor", streak: 14, completed: 2, goal: 3, unit: "Trips", frequency: "This Week"),
        Habit(name: "Read", isGroupHabit: false, category: "Education", streak: 15, completed: 20, goal: 20, unit: "Pages", frequency: "Today"),
        Habit(name: "Drink Protein", isGroupHabit: false, category: "Nutrition", streak: 8, completed: 2, goal: 2, unit: "Shakes", frequency: "This Week"),
        Habit(name: "Tutor", isGroupHabit: true, category: "Teaching", streak: 6, completed: 2, goal: 2, unit: "Sessions", frequency: "This Week"),
        Habit(name: "Meditate", isGroupHabit: false, category: "Mindfulness", streak: 10, completed: 1, goal: 1, unit: "Session", frequency: "Today")
    ]
}

// MARK: - ViewModel
class HabitsViewModel {
    private var habits: [Habit] = []
    
    init() {
        loadHabits()
    }
    
    func loadHabits() {
        habits = HabitData.habits.sorted { ($0.completed * 100 / $0.goal) > ($1.completed * 100 / $1.goal) }
    }
    
    func numberOfHabits() -> Int {
        return habits.count
    }
    
    func habit(at index: Int) -> Habit {
        return habits[index]
    }
}

// MARK: - Custom Habit Cell
class HabitCell: UITableViewCell {
    static let identifier = "HabitCell"
    
    private let nameLabel = UILabel()
    private let groupIconLabel = UILabel()
    private let streakLabel = UILabel()
    private let progressLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        streakLabel.font = .systemFont(ofSize: 14)
        progressLabel.font = .systemFont(ofSize: 14)
        groupIconLabel.font = .systemFont(ofSize: 16)
        
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusButton.tintColor = .blue
        
        let nameStack = UIStackView(arrangedSubviews: [nameLabel, groupIconLabel, streakLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 8
        nameStack.alignment = .leading
        
        let mainStack = UIStackView(arrangedSubviews: [nameStack, progressLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        
        let containerStack = UIStackView(arrangedSubviews: [mainStack, plusButton])
        containerStack.axis = .horizontal
        containerStack.spacing = 8
        containerStack.alignment = .center
        containerStack.distribution = .fill
        
        contentView.addSubview(containerStack)
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            plusButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with habit: Habit) {
        nameLabel.text = habit.name
        groupIconLabel.text = habit.isGroupHabit ? "👥" : ""
        streakLabel.text = "🔥 \(habit.streak) days"
        progressLabel.text = "\(habit.completed) / \(habit.goal) \(habit.unit) \(habit.frequency)"
    }
}

// MARK: - Habits ViewController
class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let viewModel = HabitsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Habits"
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        // Left button to change habit view
        let changeViewButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(changeViewTapped))
        navigationItem.leftBarButtonItem = changeViewButton
        
        // Right buttons (Grid View & Add Habit)
        let gridViewButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(gridViewTapped))
        let addHabitButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addHabitTapped))
        
        navigationItem.rightBarButtonItems = [addHabitButton, gridViewButton]
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfHabits()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as! HabitCell
        cell.configure(with: viewModel.habit(at: indexPath.row))
        return cell
    }
    
    // MARK: - Button Actions
    @objc private func changeViewTapped() {
        print("Change View button tapped")
    }
    
    @objc private func gridViewTapped() {
        print("Grid View button tapped")
    }
    
    @objc private func addHabitTapped() {
        print("Add Habit button tapped")
    }
}

