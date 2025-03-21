//
//  LoginViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewController: UIViewController, AuthViewDelegate {
    
    // MARK: - Properties
    private let authView = AuthView()
    var screenType: AuthScreenType
    
    init(screenType: AuthScreenType) {
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.delegate = self
        setupUI()
    }
}


// MARK: - UI Setup
extension AuthenticationViewController {
    private func setupUI () {
        view.backgroundColor = .systemBackground
        view.addSubview(authView)
        setupConstraints()
        configureScreen()
    }
    
    private func setupConstraints() {
        authView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            authView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            authView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            authView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureScreen() {
        switch screenType {
        case .login:
            updateAuthView(
                title: "Welcome to Motivo!",
                subtitle: "Build your habits",
                actionTitle: "Login",
                switchLabel: "Don’t have an account? ",
                switchButtonTitle: "Register!",
                hiddenViews: [authView.usernameTextField, authView.verifyPasswordTextField]
            )
            
        case .register:
            updateAuthView(
                title: "Register",
                subtitle: "Get started here",
                actionTitle: "Create Account",
                switchLabel: "Already have an account? ",
                switchButtonTitle: "Log in",
                hiddenViews: [authView.forgetPasswordButton]
            )

        case .forgetPassword:
            updateAuthView(
                title: "Forget Password",
                subtitle: "Recover your account",
                actionTitle: "Reset Password",
                switchLabel: "Back to ",
                switchButtonTitle: "Login!",
                hiddenViews: [authView.usernameTextField, authView.passwordTextField, authView.verifyPasswordTextField, authView.forgetPasswordButton]
            )
        }
    }
    
    private func updateAuthView(title:String, subtitle:String, actionTitle:String, switchLabel: String, switchButtonTitle: String, hiddenViews: [UIView]) {
        authView.titleLabel.text = title
        authView.subtitleLabel.text = subtitle
        authView.actionButton.setTitle(actionTitle, for: .normal)
        authView.switchScreenLabel.text = switchLabel
        authView.switchScreenButton.setTitle(switchButtonTitle, for: .normal)
        
        // Show all views first
        [
            authView.usernameTextField,
            authView.emailTextField,
            authView.passwordTextField,
            authView.verifyPasswordTextField,
            authView.forgetPasswordButton
        ].forEach { view in view.isHidden = false}
        
        // Hide specified views
        hiddenViews.forEach {view in view.isHidden = true}
    }
}

// MARK: - AuthView Delegate Actions
extension AuthenticationViewController {
    // Handles action for Login, Create Account, and Forget Password button
    func actionButtonTapped() {
        switch screenType {
        case .login:
            // TODO: Complete input validation
            guard let emailText = authView.emailTextField.text else { return }
            guard let passwordText = authView.passwordTextField.text else { return }
            handleLogin(email: emailText, password: passwordText)
            
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
            
            handleRegister(email: emailText, username: usernameText,password: passwordText)
            
        case .forgetPassword:
            guard let emailText = authView.emailTextField.text else {
                AlertUtils.shared.showAlert(self, title: "Registration Failed", message: "Passwords do not match.")
                return
            }
            
            handleForgetPassword(email: emailText)
        }
    }
    
    // Handles switching between authentication screens
    func switchScreenPromptTapped() {
        guard let parentVC = self.parent as? AuthFlowViewController else { return }
    
        let newScreenType: AuthScreenType
        switch self.screenType {
        case .login:
            newScreenType = .register
        case .register, .forgetPassword:
            newScreenType = .login
        }

        parentVC.switchTo(screenType: newScreenType)
    }
    
    // Handles forget password switch
    func forgetPasswordTapped() {
        guard let parentVC = self.parent as? AuthFlowViewController else { return }
        parentVC.switchTo(screenType: .forgetPassword)
    }
}

// MARK: - Authentication Handlers
extension AuthenticationViewController {
    // Performs a FireBaseAuth login using provided credentials
    private func handleLogin(email: String, password: String) {
        Task {
            do {
                _ = try await AuthManager.shared.signInAsync(email: email, password: password)
            } catch {
                let errorText = "\(error.localizedDescription)"
                AlertUtils.shared.showAlert(self, title: "Login Failed", message: errorText)
            }
        }
    }
    
    // Performs a FireBaseAuth register using provided credentials
    private func handleRegister(email:String, username:String, password:String) {
        AuthManager.shared.isRegisteringUser = true  // Registration Flag Start
        
        Task {
            do {
                let authResult = try await AuthManager.shared.registerAsync(email: email, password: password)
                
                // Create user model and insert into user collections in db
                let newUser = UserModel(id: authResult.user.uid, username: username, email: email)
                try AuthManager.shared.insertUserData(user: newUser)
            } catch {
                let errorText = "\(error.localizedDescription)"
                AlertUtils.shared.showAlert(self, title: "Registration Failed", message: errorText) {
                    Task {
                        // Remove newly created FirebaseAuth user to prevent ghost user
                        try? await Auth.auth().currentUser?.delete()
                        try? Auth.auth().signOut()
                    }
                }
            }
            
            AuthManager.shared.isRegisteringUser = false  // Registration Flag End
        }
    }
    
    // Performs a FireBaseAuth password reset using provided email
    private func handleForgetPassword(email:String) {
        Task {
            do {
                try await AuthManager.shared.resetPassword(email: email)
                AlertUtils.shared.showAlert(self, title: "Password Reset", message: "A password recovery email has been sent with instructions to reset your password.")
            } catch {
                let errorText = "\(error.localizedDescription)"
                AlertUtils.shared.showAlert(self, title: "Password Reset Failed", message: errorText)
            }
        }
    }
}
