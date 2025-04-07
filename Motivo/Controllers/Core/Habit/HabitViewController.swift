import UIKit

class HabitViewController: UIViewController {
    
    // MARK: UI Elements
    private let habitsView = HabitsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHabits()
    }
    
    private func loadHabits() {
        Task {
            do {
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                
                let habits = try await FirestoreService.shared.fetchHabits(forUserUID: user.uid)
                habitsView.habits = habits
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch habits")
            }
        }
    }
}

// MARK: - UI Setup
extension HabitViewController {
    private func setupUI() {
        setupTitleBar()
        
        view.addSubview(habitsView)
        
        habitsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitsView.topAnchor.constraint(equalTo: view.topAnchor),
            habitsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTitleBar() {
        title = "Habits"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))
    }
}


// MARK: - Actions
extension HabitViewController {
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
}
