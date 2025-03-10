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
    
    var screenType: AuthScreenType
    
    // Shared UI Elements
    // TODO: Add logo element
    private let titleLabel = UILabel() // Register, Login, Forget Password
    private let subtitleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let verifyPasswordTextField = UITextField()
    // TODO: Change this to no type and add custom style/properties (look into setting up color/style file. maybe a plist)
    private let actionButton = UIButton()
    private let forgetPasswordButton = UIButton()
    private let switchScreenLabel = UILabel()
    private let switchScreenButton = UIButton()
    
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
        
        Auth.auth().addStateDidChangeListener() {
            (auth,user) in
            if user != nil {
                self.segueToHomeVC()
//                self.performSegue(withIdentifier: self.segueIdentifier, sender:nil)
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
        
        setupUI()
        configureScreen()
    }
    
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
        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        
        // Forget Password Button
        forgetPasswordButton.setTitleColor(.systemRed, for: .normal)
        forgetPasswordButton.setTitle("Forget Password?", for: .normal)
        forgetPasswordButton.addTarget(self, action: #selector(handleForgetPasswordSwitchScreen), for: .touchUpInside)
        
        // SwitchScreen Label
//        switchScreenLabel.textAlignment = .right
        
        // Switch Screen Button
        // switchScreenButton.setTitleColor(.systemBlue, for: .normal)
        switchScreenButton.setTitleColor(.systemRed, for: .normal)
        switchScreenButton.addTarget(self, action: #selector(handleSwitchScreen), for: .touchUpInside)

        // Combine Switch Screen Button and Label into one prompt stack
        let switchScreenPromptStack = UIStackView(arrangedSubviews: [switchScreenLabel, switchScreenButton])
        switchScreenPromptStack.axis = .horizontal
        switchScreenPromptStack.spacing = 0 // TODO: Adjust spacing
        
        // Add Subviews
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, usernameTextField, emailTextField, passwordTextField, verifyPasswordTextField, actionButton, forgetPasswordButton, switchScreenPromptStack])
        stackView.axis = .vertical
        stackView.spacing = 15  // TODO: look into if this conflicts with constraints
        view.addSubview(stackView)

        // Auto Layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func configureScreen() {
        switch screenType {
        case .login:
            titleLabel.text = "Welcome to Motivo!"
            subtitleLabel.text = "Build your habits"
            actionButton.setTitle("Login", for: .normal)
            switchScreenLabel.text = "Don’t have an account? "
            switchScreenButton.setTitle("Register!", for: .normal)
            usernameTextField.isHidden = true
            emailTextField.isHidden = false
            verifyPasswordTextField.isHidden = true
            forgetPasswordButton.isHidden = false
            
        case .register:
            titleLabel.text = "Register"
            subtitleLabel.text = "Get started here"
            actionButton.setTitle("Create Account", for: .normal)
            switchScreenLabel.text = "Already have an account? "
            switchScreenButton.setTitle("Log in", for: .normal)
            emailTextField.isHidden = false
            verifyPasswordTextField.isHidden = false
            forgetPasswordButton.isHidden = true

        case .forgotPassword:
            titleLabel.text = "Forget Password"
            subtitleLabel.text = "Recover your account"
            actionButton.setTitle("Reset Password", for: .normal)
            switchScreenLabel.text = "Back to "
            switchScreenButton.setTitle("Login!", for: .normal)
            emailTextField.isHidden = false
            usernameTextField.isHidden = true
            passwordTextField.isHidden = true
            verifyPasswordTextField.isHidden = true
            forgetPasswordButton.isHidden = true
        }
    }
    
    @objc func handleActionButton() {
        switch screenType {
        case .login:
            
            Auth.auth().signIn(
                withEmail: emailTextField.text!,
                password: passwordTextField.text!) {
                    (authResult,error) in
                    if let error = error as NSError? {
                        // Login fail
                        let errorText = "\(error.localizedDescription)"
                        self.handleAuthErrorAlerts(alertTitle: "Login Failed", errorText: errorText)
                        
                    } else {
                        // Login success
                        print(authResult!)
                    }
                }

        case .register:
            // TODO: Add field validation (verify matching passwords, username/password criteria, check email format)
            // TODO: Move into validation function and combine error messages to include messages from multiple faulty fields
            // Empty Field Validation
            guard let emailText = emailTextField.text else { return }
            guard let usernameText = usernameTextField.text else { return }
            guard let passwordText = emailTextField.text else { return }
            
            // Password Match Validation
            guard passwordTextField.text == verifyPasswordTextField.text else {
                self.handleAuthErrorAlerts(alertTitle: "Registration Failed", errorText: "Passwords do not match.")
                return
            }
            
            Task {
                do {
                    let authResult = try await createUserAsync(email: emailText, password: passwordText)
                    print("User created: \(authResult.user.uid)")
                } catch {
                    // Handle Registration Errors
                    let errorText = "\(error.localizedDescription)"
                    self.handleAuthErrorAlerts(alertTitle: "Registration Failed", errorText: errorText)
                    
                    return
                }
                
                // TODO: Address edgecase where user registers successfully, but user collection is not created. Rollback registration and prevent auto-log in
                
                // Create user model and insert into user collections in db
                let newUser = UserModel(username: usernameText, email: emailText)
                await insertUserDataAsync(user: newUser)
            }
            
            
        case .forgotPassword:
            // TODO: Add email recovery
            break
        }
    }
    
    @objc func handleSwitchScreen() {
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

        // Add transition effect
//        let transition = CATransition()
//        transition.type = .push
//        transition.subtype = .fromRight // Swipe left effect
//        transition.duration = 0.3
//        window.layer.add(transition, forKey: kCATransition)
        
    }
    
    @objc func handleForgetPasswordSwitchScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let authVC = AuthenticationViewController(screenType: .forgotPassword)
        authVC.modalPresentationStyle = .fullScreen
        
        // Swap the root view controller (instant switch, no modal stacking)
        window.rootViewController = authVC
        window.makeKeyAndVisible()
    }

    private func segueToHomeVC() {
        let tabBarVC = MainTabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen // Prevents swipe-to-dismiss
        present(tabBarVC, animated: true)
    }
    
    private func handleAuthErrorAlerts(alertTitle:String, errorText:String) {
        let errorAlert = UIAlertController(title: alertTitle, message: errorText, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(dismissAction)
        self.present(errorAlert, animated: true)
    }
    
    // Register User in Firebase Authentication. Returns AuthDataResult or throws error if unsuccessful.
    private func createUserAsync(email:String, password:String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation {continuation in
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (authResult,error) in
                if let error = error as NSError? {
                    continuation.resume(throwing: error) // TODO: How do we make this make sense
                } else if let authResult = authResult {
                    continuation.resume(returning: authResult)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])) // TODO: How do we make this make sense
                }
            }
        }
    }
    
    private func insertUserDataAsync(user: UserModel) async {
        let db = Firestore.firestore()
        
        do {
            try await db.collection("user").document().setData([
                "email": user.email,
                "username": user.username,
            ])
            print("Document successfully written!")
        } catch {
            // TODO: Remove successful user registration if document insertion fails
            let errorText = "\(error.localizedDescription)"
            self.handleAuthErrorAlerts(alertTitle: "User Document Insertion Error", errorText: errorText)
            print("Error writing document: \(error)")
        }
    }
}
