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
    private let habitView = HabitView()
    
    // MARK: - Properties
    private let habitManager = HabitManager()
    
    // Temp storage for the habit record during image upload flow.
    // objc_getAssociatedObject could work as replacement for future refinements
    var activeHabitRecord: HabitRecord?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        habitView.delegate = self
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        Task {
            await loadHabitData()
        }
    }
}

// MARK: - Load Data
extension HabitViewController {
    private func getStoredSelectedCategoryIDs() -> [String] {
        if let selectedCategoryIDs =
            UserDefaults.standard.array(forKey: UserDefaultKeys.selectedCategoryIDs) as? [String] {
            return selectedCategoryIDs
        }
        
        return []
    }
    
    private func loadHabitData() async {
        do {
            guard let user = AuthManager.shared.getCurrentUserAuthInstance() else {
                AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "User session lost")
                return
            }
            
            // Retrieve category filter froom userDefaults
            let selectedCategoryIDs = getStoredSelectedCategoryIDs()
            
            // Concurrently fetch independent data
            async let categoriesTask = try await habitManager.fetchCategories()
            async let activeHabitWithRecordsTask = try await habitManager.fetchActiveHabitWithRecords(forUserUID: user.uid)

            let (fetchedCategories, fetchedActiveHabitWithRecords) = try await (
                categoriesTask, activeHabitWithRecordsTask
            )
            
            let categories = fetchedCategories
            var habitWithRecordList = fetchedActiveHabitWithRecords
            
            // Filter habits to only be selected habits
            habitWithRecordList = filter(habitWithRecordList, withCategoryIDs: selectedCategoryIDs)

            // Configure habit view
            habitView.configure(withCategories: categories, withHabitWithRecordList: habitWithRecordList)
            
        } catch {
            AlertUtils.shared.showAlert(self, title: "Something went wrong", message: "Unable to load habit data")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func filter(
        _ habitWithRecordList: [HabitWithRecord],
        withCategoryIDs categoryIDs: [String]
    ) -> [HabitWithRecord] {
        let filteredHabitWithRecordList = habitWithRecordList.filter {
            // Check if habit contains any of the selected category ids
            let containsAnySelectedCategory = $0.habit.categoryIDs.contains { habitCategoryID in
                categoryIDs.contains(habitCategoryID)
            }
            // Add habitWithRecord if it contains one of the category ids
            return containsAnySelectedCategory
        }

        return filteredHabitWithRecordList
    }
}


// MARK: - UI Setup
extension HabitViewController {
    private func setupUI() {
        setupNavigationBarButtons()
        view.addSubview(habitView)
        
        habitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitView.topAnchor.constraint(equalTo: view.topAnchor),
            habitView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBarButtons() {
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
    func plusButtonTapped(on habitWithRecord: HabitWithRecord) {
        activeHabitRecord = habitWithRecord.record
            
        // Show camera and upload photo
        showMockCamera()
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
                
                // Reload habit view data
                await loadHabitData()
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
