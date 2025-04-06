////
////  CameraController.swift
////  Motivo
////
////  Created by Aaron Lee on 4/6/25.
////
//
//// Credits: https://medium.com/@mijick/how-to-implement-camera-in-a-swift-way-30485d9fbb8d
//
//import UIKit
//
//struct CameraController: UIView {
//    @ObservedObject var cameraManager: CameraManager = .init()
//    @State var cameraError: CameraManager.Error?
//
//    
//    var body: some UIView {
//        ZStack { switch cameraError {
//            case .some(let error): createErrorStateView(error)
//            case nil: createCameraView()
//        }}
//        .onAppear(perform: checkCameraPermissions)
//    }
//}
//
//private extension CameraController {
//    func checkCameraPermissions() {
//        do { try cameraManager.checkPermissions() }
//        catch { cameraError = error as? CameraManager.Error }
//    }
//}
