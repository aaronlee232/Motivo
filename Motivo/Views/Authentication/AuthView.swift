//
//  AuthView.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//

import UIKit

protocol AuthViewDelegate {
    func actionButtonTapped()
    func switchScreenPromptTapped()
    func forgetPasswordTapped()
}

class AuthView: UIView {
    var delegate: AuthViewDelegate?
    
    let logoImageView = UIImageView()
    let titleLabel = BoldTitleLabel() // Register, Login, Forget Password
    let subtitleLabel = SubtitleLabel()
    let usernameTextField = GreyTextField(placeholderText: "Username", isSecure: false)
    let emailTextField = GreyTextField(placeholderText: "Email", isSecure: false)
    let passwordTextField = GreyTextField(placeholderText: "Password", isSecure: true)
    let verifyPasswordTextField = GreyTextField(placeholderText: "Verify Password", isSecure: true)
    let actionButton = ActionButton()
    let forgetPasswordButton = LinkButton()
    let switchScreenLabel = NormalLabel()
    let switchScreenButton = LinkButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // Sets common and unchanging attributes for subViews
    private func setupUI() {
        // Logo Image
        logoImageView.image = UIImage(named: "Logo") // SF Symbol as a placeholder
        logoImageView.tintColor = .gray
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 75 // 150px / 2 to make it circular
        addSubview(logoImageView)
        
        // Title
        addSubview(titleLabel)
        
        // Subtitle
        addSubview(subtitleLabel)
        
        // Input Field Stack
        let inputFieldStackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, verifyPasswordTextField])
        inputFieldStackView.axis = .vertical
        inputFieldStackView.distribution = .fillEqually
        inputFieldStackView.spacing = 12
        addSubview(inputFieldStackView)
        
        // Action Button
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        addSubview(actionButton)
        
        // Forget Password Button
        forgetPasswordButton.setTitle("Forget Password?", for: .normal)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordTapped), for: .touchUpInside)
        addSubview(forgetPasswordButton)
        
        // SwitchScreen Prompt
        switchScreenLabel.changeFontSize(fontSize: 14)
        switchScreenLabel.setContentHuggingPriority(.required, for: .horizontal)
        switchScreenLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        switchScreenButton.changeFontSize(fontSize: 14)
        switchScreenButton.setContentHuggingPriority(.required, for: .horizontal)
        switchScreenButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchScreenButton.addTarget(self, action: #selector(switchScreenPromptTapped), for: .touchUpInside)
        
        let switchScreenContainer = UIStackView(arrangedSubviews: [switchScreenLabel, switchScreenButton])
        switchScreenContainer.axis = .horizontal
        switchScreenContainer.alignment = .center
        switchScreenContainer.distribution = .fillProportionally
        
        let switchScreenContainerOuter = UIStackView(arrangedSubviews: [switchScreenContainer])
        addSubview(switchScreenContainerOuter)

        // Enable Auto Layout
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        inputFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        switchScreenContainerOuter.translatesAutoresizingMaskIntoConstraints = false
        
        // Define Constraints
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            inputFieldStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            inputFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            actionButton.topAnchor.constraint(equalTo: inputFieldStackView.bottomAnchor, constant: 24),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 24),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            switchScreenContainerOuter.centerXAnchor.constraint(equalTo: centerXAnchor),
            switchScreenContainerOuter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    @objc func forgetPasswordTapped() {
        delegate?.forgetPasswordTapped()
    }
    @objc func switchScreenPromptTapped() {
        delegate?.switchScreenPromptTapped()
    }
    @objc func actionButtonTapped() {
        delegate?.actionButtonTapped()
    }
}
