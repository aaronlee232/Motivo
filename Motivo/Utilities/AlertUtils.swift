//
//  AlertUtils.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/11/25.
//
import UIKit

class AlertUtils {
    // Singleton
    static let shared = AlertUtils()
    
    private init() {}
    
    // Creates alert based on title and message
    func showAlert(_ target:UIViewController, title:String, message:String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(dismissAction)
        target.present(errorAlert, animated: true)
    }
}
