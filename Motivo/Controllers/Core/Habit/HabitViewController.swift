import UIKit
import FirebaseStorage

// MARK: - Setup MockImagePicker
// Used for simulator without camera
#if targetEnvironment(simulator)
import MockImagePicker
typealias UIImagePickerController = MockImagePicker
typealias UIImagePickerControllerDelegate = MockImagePickerDelegate
#endif

class HabitViewController: UIViewController {
    
    // MARK: UI Elements
    private let habitsView = HabitsView()
    
    // MARK: - Properties
    private let habitManager = HabitManager()
    private var selectedCategoryIDs: [String] = []
    
    // Temp storage for the habit record during image upload flow.
    var activeHabitRecord: HabitRecord?

    // MARK: - Lifecycle
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
}

// MARK: - Load Data
extension HabitViewController {
    private func loadCategories() {
        Task {
            do {
                let categories = try await habitManager.fetchCategories()
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
                
                let habits = try await habitManager.fetchHabits(forUserUID: user.uid)
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
extension HabitViewController: HabitViewDelegate {
    // Handler for opening camera and uploading photo as proof of task completion. Will start as "unverified"
    func plusButtonTapped(with habit: HabitModel) {
        Task {
            do {
                let existingRecords = try await FirestoreService.shared.fetchHabitRecords(forHabitID: habit.id)

                // if an existing active habit record is found
                // TODO: replace this with a stricter check for "active" record based on timestamps later
                if let existingRecord = existingRecords.first {
                    activeHabitRecord = existingRecord
                } else {
                    activeHabitRecord = HabitRecord(habitID: habit.id,
                                              unverifiedPhotoURLs: [],
                                              verifiedPhotoURLs: [],
                                              timestamp: Date().formatted(),
                                              userUID: habit.userUID)
                    try habitManager.addHabitRecord(habitRecord: activeHabitRecord!)
                }
                
                // Show camera and upload photo
                showMockCamera()

            } catch {
                AlertUtils.shared.showAlert(
                    self,
                    title: "Something went wrong",
                    message: "Unable to update habit progress"
                )
            }
        }
    }
}


// MARK: - Camera Setup
extension HabitViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // Function to present the UIImagePickerController
    @objc func showMockCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    // Delegate method to handle the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        defer { dismiss(animated: true) }

        // No image selected
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        // Upload image to active habitRecord of habit
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // Add image into unverified photo list of activeHabitRecord
                let url = try await habitManager.uploadHabitPhoto(image: image)
                activeHabitRecord!.unverifiedPhotoURLs.append(url.absoluteString)
                
                // Update the active habit record
                try await habitManager.updateHabitRecord(withHabitRecord: activeHabitRecord!)
            } catch {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to upload image")
            }
        }
    }

    // Delegate method to handle cancellation of the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
