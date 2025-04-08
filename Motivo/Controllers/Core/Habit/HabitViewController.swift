import UIKit

class HabitViewController: UIViewController, HabitViewDelegate {
    
    // MARK: UI Elements
    private let habitsView = HabitsView()
    
    // MARK: - Properties
    private var selectedCategoryIDs: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        habitsView.delegate = self
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
        loadHabitFilter()
        loadHabits()
    }
    
    private func loadCategories() {
        Task {
            do {
                let categories = try await FirestoreService.shared.fetchCategories()
                habitsView.categories = categories
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch categories")
            }
        }
    }
    
    private func loadHabits() {
        Task {
            do {
                guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                    AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                    return
                }
                
                let habits = try await FirestoreService.shared.fetchHabits(forUserUID: user.uid)
                habitsView.habits = filterHabits(habits: habits)
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to fetch habits")
            }
        }
    }
    
    private func loadHabitFilter() {
        if let selectedCategoryIDs = UserDefaults.standard.array(forKey: UserDefaultKeys.selectedCategoryIDs) as? [String] {
            self.selectedCategoryIDs = selectedCategoryIDs
        }
    }
    
    private func filterHabits(habits: [HabitModel]) -> [HabitModel] {
        var filteredHabits: [HabitModel] = []
        
        habits.forEach { habit in
            // Filter by selected category IDs
            let containsSelectedCategory = habit.categoryIDs.contains { categoryID in
                selectedCategoryIDs.contains(categoryID)
            }
            
            // TODO: Add additional filters conditions here
            
            if (containsSelectedCategory) {
                filteredHabits.append(habit)
            }
        }
        
        return filteredHabits
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

// MARK: - HabitViewDelegate
extension HabitViewController {
    // Handler for opening camera and uploading photo as proof of task completion. Will start as "unverified"
    func plusButtonTapped(with habit: HabitModel) {
        print("tapped \(habit.name) cell")
        
        // TODO: Add camera and image uplaod logic
    }
}
