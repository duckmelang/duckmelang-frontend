//
//  CompleteResetPasswordViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit

class CompleteResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = completeResetPasswordView
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var completeResetPasswordView: CompleteResetPasswordView = {
        let view = CompleteResetPasswordView()
        view.loginBtn.addTarget(self, action: #selector(goLogin), for: .touchUpInside)
        return view
    }()
    
    private func setupNavigationBar() {
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func goLogin() {
        guard let navController = self.navigationController else { return }
        
        let onboardingVC = OnBoardingViewController()
        let loginVC = LoginViewController()
        
        // 온보딩 → 로그인 순으로 스택 재설정
        navController.setViewControllers([onboardingVC, loginVC], animated: true)
    }
}
