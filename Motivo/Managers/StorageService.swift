//
//  StorageService.swift
//  Motivo
//
//  Created by Aaron Lee on 4/8/25.
//

import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()
    
    func uploadPhoto(_ image: UIImage) async throws -> URL {
        let imageData = try convertToJPEGData(image)

        let imageRef = Storage.storage().reference()
            .child("habit_photos/\(UUID().uuidString).jpg")

        // Upload data
        try await putData(imageRef: imageRef, data: imageData)

        // Get download URL
        return try await getDownloadURL(from: imageRef)
        
    }

    private func putData(imageRef: StorageReference, data: Data) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            imageRef.putData(data, metadata: nil) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func getDownloadURL(from ref: StorageReference) async throws -> URL {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            ref.downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
        }
    }
    
    func convertToJPEGData(_ image: UIImage) throws -> Data {
        enum ImageConversionError: Error {
            case jpegConversionFailed
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageConversionError.jpegConversionFailed
        }
        return imageData
    }
}
