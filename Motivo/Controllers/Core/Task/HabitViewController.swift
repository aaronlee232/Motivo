//
//  HabitViewController.swift
//  Motivo
//
//  Created by Cooper Wilk on 3/10/25.
//

import UIKit
import FirebaseFirestore

class HabitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var habits: [HabitModel] = []
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Habits"
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        fetchHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHabits()  // Reload data from Firebase
    }
    
    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
        let addHabitButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addHabitTapped))
        navigationItem.rightBarButtonItem = addHabitButton
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
    
    @objc private func addHabitTapped() {
        let addHabitVC = AddHabitViewController()
        navigationController?.pushViewController(addHabitVC, animated: true)
    }
    
    // MARK: - Fetch Data from Firebase
    private func fetchHabits() {
        db.collection("habits").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching habits: \(error.localizedDescription)")
                return
            }
            
            self.habits = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return HabitModel(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    isGroupHabit: data["isGroupHabit"] as? Bool ?? false,
                    category: (data["category"] as? [String])?.joined(separator: ", ") ?? "",
                    streak: data["streak"] as? Int ?? 0,
                    completed: data["completed"] as? Int ?? 0,
                    goal: data["goal"] as? Int ?? 0,
                    unit: data["unit"] as? String ?? "",
                    frequency: data["frequency"] as? String ?? "Daily"
                )
            } ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as! HabitCell
        let habit = habits[indexPath.row]
        cell.configure(with: habit, isExpanded: true)
        return cell
    }
}
