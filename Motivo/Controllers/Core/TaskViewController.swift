//
//  TaskViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/10/25.
//
import UIKit


// TODO: Remove and connect to Firebase
class HabitData {
    static var habits: [Habit] = [
        Habit(name: "Exercise", isGroupHabit: true, category: "Exercise", streak: 5, completed: 1, goal: 3, unit: "Times", frequency: "Today"),
        Habit(name: "Drink Water", isGroupHabit: false, category: "Nutrition", streak: 7, completed: 2, goal: 3, unit: "Glasses", frequency: "Today"),
        Habit(name: "Hike", isGroupHabit: true, category: "Social", streak: 14, completed: 2, goal: 3, unit: "Trips", frequency: "This Week"),
        Habit(name: "Read", isGroupHabit: false, category: "Productivity", streak: 15, completed: 18, goal: 20, unit: "Pages", frequency: "Today"),
        Habit(name: "Drink Protein", isGroupHabit: false, category: "Nutrition", streak: 8, completed: 1, goal: 2, unit: "Shakes", frequency: "This Week"),
        Habit(name: "Tutor", isGroupHabit: true, category: "Finance", streak: 6, completed: 2, goal: 2, unit: "Sessions", frequency: "This Week"),
        Habit(name: "Meditate", isGroupHabit: false, category: "Nutrition", streak: 10, completed: 1, goal: 1, unit: "Session", frequency: "Today")
    ]
}


class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var viewModel = HabitsView()
    private var isExpandedView = false // Toggle for expanded/compact views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Habits"
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadHabits()  // Reload data
        tableView.reloadData()   // Refresh UI
    }
    
    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
        let changeViewButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(changeViewTapped))
        let gridViewButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(gridViewTapped))
        let addHabitButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addHabitTapped))
        
        navigationItem.leftBarButtonItem = changeViewButton
        navigationItem.rightBarButtonItems = [addHabitButton, gridViewButton]
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Button Actions
    @objc private func changeViewTapped() {
        let settingsVC = TaskSettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    
    @objc private func gridViewTapped() {
        isExpandedView.toggle()  // Toggle the expanded state
        
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
    
    @objc private func addHabitTapped() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfHabits()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as! HabitCell
        let habit = viewModel.habit(at: indexPath.row)
        cell.configure(with: habit, isExpanded: isExpandedView)
        cell.onPlusTapped = {
            self.viewModel.updateHabit(at: indexPath.row)
            UIView.transition(with: self.tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: nil)
        }
        return cell
    }
}
