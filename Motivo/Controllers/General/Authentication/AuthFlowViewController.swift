//
//  AuthFlowViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/14/25.
//

import UIKit

enum AuthScreenType {
    case login
    case register
    case forgetPassword
}

class AuthFlowViewController: UIViewController {
    
    private var currentScreen: AuthenticationViewController?

    init(screenType:AuthScreenType = .login) {
        self.currentScreen = AuthenticationViewController(screenType: screenType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchTo(screenType: .login)
    }
    
    func switchTo(screenType: AuthScreenType) {
        let newScreen = AuthenticationViewController(screenType: screenType)
        addChild(newScreen)
        view.addSubview(newScreen.view)
        newScreen.view.frame = view.bounds
        newScreen.didMove(toParent: self)
        
        if let currentScreen = currentScreen {
            UIView.transition(from: currentScreen.view, to: newScreen.view, duration: 0.3) {
                _ in
                currentScreen.willMove(toParent: nil)
                currentScreen.view.removeFromSuperview()
                currentScreen.removeFromParent()
            }
        }
        
        currentScreen = newScreen
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
