//
//  UIViewController+Alert.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        AlertUtils.shared.showAlert(self, title: title, message: message)
    }
}
