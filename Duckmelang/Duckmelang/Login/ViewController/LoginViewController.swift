//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        self.title = "로그인"
        
        // 네비게이션 바 타이틀 폰트 설정
        if let navigationController = self.navigationController {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont
                    .aritaSemiBoldFont(ofSize: 18)
            ]
        }
    }
    
    // MARK: - Properties
        
    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.loginButton
            .addTarget(
                self,
                action: #selector(didTapLoginButton),
                for: .touchUpInside
            )
        return view
    }()

    
    
    @objc private func didTapLoginButton() {
        navigateToHomeView()
        print("gotoMain")
    }
    
    // MARK: - Navigation
    
    private func navigateToHomeView() {
        let mainVC = BaseViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }

}
