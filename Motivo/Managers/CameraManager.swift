////
////  CameraManager.swift
////  Motivo
////
////  Created by Aaron Lee on 4/6/25.
////
//
//// Credit: https://medium.com/@mijick/how-to-implement-camera-in-a-swift-way-30485d9fbb8d
//
//import AVFoundation
//
//class CameraManager: NSObject {
//    enum CameraError: Swift.Error {  // TODO: possibly change swift.error
//        case cameraPermissionsNotGranted
//    }
//
//    func checkPermissions() throws {
//        let status = AVCaptureDevice.authorizationStatus(for: .video)
//        if status == .denied {
//            throw CameraError.cameraPermissionsNotGranted
//        }
//    }
//}
