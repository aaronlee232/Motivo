//
//  ChatViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

// MARK: - Setup MockImagePicker
// Used for simulator without camera
#if targetEnvironment(simulator)
import MockImagePicker
typealias UIImagePickerController = MockImagePicker
typealias UIImagePickerControllerDelegate = MockImagePickerDelegate
#endif

import UIKit
import FirebaseStorage

let dummyHabitList1: [DummyHabit] = [
    DummyHabit(name: "Charge phone", habitStatus: .incomplete),
    DummyHabit(name: "Wash dishes", habitStatus: .complete),
    DummyHabit(name: "Run a mile", habitStatus: .pending),
    DummyHabit(name: "Do homework", habitStatus: .incomplete),
    DummyHabit(name: "Cook dinner", habitStatus: .complete)
]


let dummyHabitList2: [DummyHabit] = [
    DummyHabit(name: "Wash dishes", habitStatus: .complete),
    DummyHabit(name: "Cook dinner", habitStatus: .complete)
]

import UIKit

class ChatViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("Camera", for: .normal)
        button.addTarget(self, action: #selector(showMockCamera), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Function to present the UIImagePickerController
    @objc func showMockCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    // Delegate method to handle the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            print("Got image 🖼 with PNG size = " + (image.pngData()?.count.description ?? "unknown"))
            uploadHabitPhoto(image)
        } else {
            print("No image 😕")
        }
        dismiss(animated: true)
    }

    // Delegate method to handle cancellation of the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // TODO: Move into FirebaseStorageService.swift
    func uploadHabitPhoto(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("habit_photos/\(UUID().uuidString).jpg")

        // Upload the image
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }

            // Get the download URL
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                print("Image uploaded successfully. URL: \(downloadURL.absoluteString)")
                print("ImageURL: ", downloadURL)
            }
        }
    }
}


/*
 COMPLETE
 Camera (Mocked)
 Image uploads (to current HabitRecord)
 Retrieve ImageURL of upload image
 insert ImageURL into existing documents (
    habitRecord.unverifiedPhotoUrls,
 )
 
 TODO
 Image fetching (show image for verification)
 UI for verification VC with controls
    move habitRecord.unverifiedPhotoUrls to habitRecord.verifiedPhotoUrls
 
 Adjust view of complete and pending tasks in habit
 
 Completed: 1/3
 Pending: 1
 
 Completed: (1) + 1/3
 
 */
