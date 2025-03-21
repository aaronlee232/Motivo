//
//  AlertUtils.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/11/25.
//
import UIKit

class AlertUtils {
    static let shared = AlertUtils()

    private init() {}

    func showAlert(_ target:UIViewController, title: String, message: String, onDismiss: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
                onDismiss?()  // Blocks until user taps OK
            }
            alert.addAction(dismissAction)
            target.present(alert, animated: true)
        }
    }
}
