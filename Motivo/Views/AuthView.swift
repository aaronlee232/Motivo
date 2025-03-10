//
//  AuthView.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//

import UIKit

class AuthView: UIView {
    // TODO: Add logo element
    let titleLabel = UILabel() // Register, Login, Forget Password
    let subtitleLabel = UILabel()
    let usernameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let verifyPasswordTextField = UITextField()
    // TODO: Change this to no type and add custom style/properties (look into setting up color/style file. maybe a plist)
    let actionButton = UIButton()
    let forgetPasswordButton = UIButton()
    let switchScreenLabel = UILabel()
    let switchScreenButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // Sets common and unchanging attributes for subViews
    private func setupUI() {
        // Title
        titleLabel.textAlignment = .center
        // titleLabel.font
        
        // Subtitle
        subtitleLabel.textAlignment = .center
        
        // Username Text Field
        usernameTextField.placeholder = "Username"
        // usernameTextField.borderStyle
        
        // Email Text Field
        emailTextField.placeholder = "Email"
        // emailTextField.borderStyle
        
        // Password Text Field
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        // passwordTextField.borderStyle
        
        // Verify Password Text Field
        verifyPasswordTextField.placeholder = "Verify Password"
        verifyPasswordTextField.isSecureTextEntry = true
        // verifyPasswordTextField.borderStyle
        
        // Action Button
        actionButton.backgroundColor = .systemRed
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 8
        
        // Forget Password Button
        forgetPasswordButton.setTitleColor(.systemRed, for: .normal)
        forgetPasswordButton.setTitle("Forget Password?", for: .normal)
        
        
        // SwitchScreen Label
        switchScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        switchScreenLabel.font = UIFont.systemFont(ofSize: 14)
        switchScreenLabel.setContentHuggingPriority(.required, for: .horizontal)
        switchScreenLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchScreenLabel.backgroundColor = .red
        
        // Switch Screen Button
        switchScreenButton.translatesAutoresizingMaskIntoConstraints = false
        switchScreenButton.setTitleColor(.systemRed, for: .normal)
        switchScreenButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        switchScreenButton.setContentHuggingPriority(.required, for: .horizontal)
        switchScreenButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchScreenButton.backgroundColor = .green
        
        // Combine Switch Screen Button and Label into one prompt stack
        let switchScreenContainer = UIView()
        switchScreenContainer.translatesAutoresizingMaskIntoConstraints = false
        switchScreenContainer.backgroundColor = .systemBlue
        switchScreenContainer.addSubview(switchScreenLabel)
        switchScreenContainer.addSubview(switchScreenButton)
        NSLayoutConstraint.activate([
            switchScreenLabel.centerYAnchor.constraint(equalTo: switchScreenContainer.centerYAnchor),
            switchScreenButton.centerYAnchor.constraint(equalTo: switchScreenContainer.centerYAnchor),
            switchScreenButton.leadingAnchor.constraint(equalTo: switchScreenLabel.trailingAnchor)
        ])
        
        // Add Subviews
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, usernameTextField, emailTextField, passwordTextField, verifyPasswordTextField, actionButton, forgetPasswordButton, switchScreenContainer])
        stackView.axis = .vertical
        stackView.spacing = 15  // TODO: look into if this conflicts with constraints
        addSubview(stackView)

        // Auto Layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // This ensures the container takes the height of the tallest subview
            switchScreenContainer.topAnchor.constraint(equalTo: switchScreenLabel.topAnchor),
            switchScreenContainer.bottomAnchor.constraint(equalTo: switchScreenLabel.bottomAnchor),
            switchScreenContainer.leadingAnchor.constraint(equalTo: switchScreenLabel.leadingAnchor),
            switchScreenContainer.trailingAnchor.constraint(equalTo: switchScreenButton.trailingAnchor),
            switchScreenContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}
