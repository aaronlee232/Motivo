//
//  LoginViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

enum AuthScreenType {
    case login
    case register
    case forgotPassword
}

class AuthenticationViewController: UIViewController {
    
    private let authView = AuthView()
    var screenType: AuthScreenType
    
    init(screenType: AuthScreenType) {
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(authView)
        setupConstraints()
        configureScreen()
        setupActions()
    }
    
    private func setupConstraints() {
        authView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authView.topAnchor.constraint(equalTo: view.topAnchor),
            authView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Changes visible elements based on Authentication screens
    private func configureScreen() {
        switch screenType {
        case .login:
            authView.titleLabel.text = "Welcome to Motivo!"
            authView.subtitleLabel.text = "Build your habits"
            authView.actionButton.setTitle("Login", for: .normal)
            authView.switchScreenLabel.text = "Don’t have an account? "
            authView.switchScreenButton.setTitle("Register!", for: .normal)
            authView.usernameTextField.isHidden = true
            authView.emailTextField.isHidden = false
            authView.verifyPasswordTextField.isHidden = true
            authView.forgetPasswordButton.isHidden = false
            
        case .register:
            authView.titleLabel.text = "Register"
            authView.subtitleLabel.text = "Get started here"
            authView.actionButton.setTitle("Create Account", for: .normal)
            authView.switchScreenLabel.text = "Already have an account? "
            authView.switchScreenButton.setTitle("Log in", for: .normal)
            authView.emailTextField.isHidden = false
            authView.verifyPasswordTextField.isHidden = false
            authView.forgetPasswordButton.isHidden = true

        case .forgotPassword:
            authView.titleLabel.text = "Forget Password"
            authView.subtitleLabel.text = "Recover your account"
            authView.actionButton.setTitle("Reset Password", for: .normal)
            authView.switchScreenLabel.text = "Back to "
            authView.switchScreenButton.setTitle("Login!", for: .normal)
            authView.emailTextField.isHidden = false
            authView.usernameTextField.isHidden = true
            authView.passwordTextField.isHidden = true
            authView.verifyPasswordTextField.isHidden = true
            authView.forgetPasswordButton.isHidden = true
        }
    }
    
    private func setupActions() {
        authView.actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        authView.forgetPasswordButton.addTarget(self, action: #selector(handleForgetPasswordSwitchScreen), for: .touchUpInside)
        authView.switchScreenButton.addTarget(self, action: #selector(handleSwitchScreen), for: .touchUpInside)
    }
    
    // Handles action for Login, Create Account, and Forget Password button
    @objc private func handleActionButton() {
        switch screenType {
        case .login:
            // TODO: Complete input validation
            guard let emailText = authView.emailTextField.text else { return }
            guard let passwordText = authView.passwordTextField.text else { return }
            
            Task {
                do {
                    let authData = try await AuthManager.shared.signInAsync(email: emailText, password: passwordText)
                } catch {
                    let errorText = "\(error.localizedDescription)"
                    AlertUtils.shared.showAlert(self, title: "Login Failed", message: errorText)
                }
            }
            
            
        case .register:
            // TODO: Add field validation (verify matching passwords, username/password criteria, check email format)
            // TODO: Move into validation function and combine error messages to include messages from multiple faulty fields
            guard let emailText = authView.emailTextField.text else { return }
            guard let usernameText = authView.usernameTextField.text else { return }
            guard let passwordText = authView.passwordTextField.text else { return }
            guard let verifyPasswordText = authView.verifyPasswordTextField.text else { return }
            
            // Password Match Validation
            guard passwordText == verifyPasswordText else {
                AlertUtils.shared.showAlert(self, title: "Registration Failed", message: "Passwords do not match.")
                return
            }
            
            // TODO: Address edgecase where user registers successfully, but user collection is not created. Rollback registration and prevent auto-log in
            Task {
                do {
                    let authResult = try await AuthManager.shared.registerAsync(email: emailText, password: passwordText)
                    
                    // Create user model and insert into user collections in db
                    let newUser = UserModel(uid: authResult.user.uid, username: usernameText, email: emailText)
                    try AuthManager.shared.insertUserDataAsync(user: newUser)
                    
                    print("User created:", authResult.user.uid)
                } catch {
                    let errorText = "\(error.localizedDescription)"
                    AlertUtils.shared.showAlert(self, title: "Registration Failed", message: errorText)
                }
            }
            
            
        case .forgotPassword:
            guard let emailText = authView.emailTextField.text else {
                AlertUtils.shared.showAlert(self, title: "Registration Failed", message: "Passwords do not match.")
                return
            }
            
            Task {
                do {
                    try await AuthManager.shared.resetPassword(email: emailText)
                    AlertUtils.shared.showAlert(self, title: "Password Reset", message: "A password recovery email has been sent with instructions to reset your password.")
                } catch {
                    let errorText = "\(error.localizedDescription)"
                    AlertUtils.shared.showAlert(self, title: "Password Reset Failed", message: errorText)
                }
            }
        }
    }
    
    // Handles switching between authentication screens
    @objc private func handleSwitchScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
    
        let newScreenType: AuthScreenType
        switch self.screenType {
        case .login:
            newScreenType = .register
        case .register, .forgotPassword:
            newScreenType = .login
        }

        let authVC = AuthenticationViewController(screenType: newScreenType)
        authVC.modalPresentationStyle = .fullScreen
        
        // Swap the root view controller (instant switch, no modal stacking)
        window.rootViewController = authVC
        window.makeKeyAndVisible()
    }
    
    // Handles forget password switch
    @objc private func handleForgetPasswordSwitchScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let authVC = AuthenticationViewController(screenType: .forgotPassword)
        authVC.modalPresentationStyle = .fullScreen
        
        // Swap the root view controller (instant switch, no modal stacking)
        window.rootViewController = authVC
        window.makeKeyAndVisible()
    }
}
