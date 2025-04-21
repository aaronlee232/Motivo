//
//  ChatViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit
import FirebaseStorage

import UIKit

class ChatViewController: UIViewController {
    
    let stubLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stubLabel.text = "Stubbed Chat Screen"
        
        view.addSubview(stubLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
