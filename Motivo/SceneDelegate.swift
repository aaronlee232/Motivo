//
//  SceneDelegate.swift
//  Motivo
//
//  Created by Aaron Lee on 3/3/25.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var authListenerHandle: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is logged in. Redirect to main page if logged in, login if otherwise.
        if Auth.auth().currentUser != nil {
            window?.rootViewController = MainTabBarViewController()
        } else {
            window?.rootViewController = AuthFlowViewController()
        }
        
        window?.makeKeyAndVisible()
        
        observeAuthState()
    }
    
    // Handles directing user to login page or main content view pages
    func observeAuthState() {
        authListenerHandle = Auth.auth().addStateDidChangeListener() {
            [weak self]  (auth,user) in
            guard let self = self else { return } // Avoid memory leaks
            
            if let user = user {
                // Login or Register Logic
                Task {
                    // Wait here if registration is still in progress
                    var retries = 3
                    while AuthManager.shared.isRegisteringUser && retries > 0 {
                        print("Waiting for registration to finish...")
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        retries -= 1
                    }
                    
                    // Check Firestore for userModel before redirecting to main screens
                    if let _ = try? await FirestoreService.shared.fetchUser(forUserUID: user.uid) {
                        DispatchQueue.main.async {
                            self.switchRootViewController(newRootViewController: MainTabBarViewController())
                        }
                        return
                    }
                }
            } else {
                // User is logged out. Show Auth Flow
                self.switchRootViewController(newRootViewController: AuthFlowViewController())
            }
        }
    }
    
    func switchRootViewController(newRootViewController: UIViewController) {
        guard let window = self.window else { return }
        window.rootViewController = newRootViewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)  // Remove listener when scene disconnects
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

