//
//  AccountClosing2ViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class AccountClosing2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = accountClosing2View
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var accountClosing2View = AccountClosing2View().then {
        $0.outBtn.addTarget(self, action: #selector(goOnboarding), for: .touchUpInside)
    }

    @objc
    private func goOnboarding() {
        let onboardingVC = OnBoardingViewController()
        let nav = UINavigationController(rootViewController: onboardingVC)
        
        // rootViewController 교체
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = scene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = nav
            delegate.window?.makeKeyAndVisible()
        }
    }
}
