//
//  ImageDownloader.swift
//  Motivo
//
//  Created by Aaron Lee on 4/18/25.
//

import UIKit
import Kingfisher

enum ImageDownloadError: Error {
    case invalidURL
    case downloadFailed(Error)
}

class ImageDownloader {
    static func fetchImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageDownloadError.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value.image)
                case .failure(let error):
                    continuation.resume(throwing: ImageDownloadError.downloadFailed(error))
                }
            }
        }
    }
}
