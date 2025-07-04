//
//  NotFoundIDViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

class NotFoundIDViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = notFoundIDView
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var notFoundIDView: NotFoundIDView = {
        let view = NotFoundIDView()
        view.loginBtn.addTarget(self, action: #selector(goOnBoarding), for: .touchUpInside)
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
    
    @objc private func goOnBoarding() {
        guard let navController = self.navigationController else { return }
        
        let onboardingVC = OnBoardingViewController()
        
        // 온보딩 → 로그인 순으로 스택 재설정
        navController.setViewControllers([onboardingVC], animated: true)
    }
}
