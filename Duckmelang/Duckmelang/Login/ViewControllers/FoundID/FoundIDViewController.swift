//
//  FoundIDViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit
import FirebaseAuth

class FoundIDViewController: UIViewController {
    var phoneNum: String = ""
    var foundId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = foundIDView
        
        foundIDView.phoneNumLabel.text = "\(phoneNum)로 저장된 아이디에요"
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var foundIDView: FoundIDView = {
        let view = FoundIDView()
        view.loginBtn.addTarget(self, action: #selector(goLogin), for: .touchUpInside)
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationItem.title = "아이디 찾기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(
            ofSize: 18
        )]
            
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
