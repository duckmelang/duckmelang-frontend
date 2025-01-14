//
//  OnBoardingViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit

class OnBoardingViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var onboardingView: OnBoardingView = {
        let view = OnBoardingView()
        view.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        view.kakaoLoginButton.addTarget(self, action: #selector(didTapKakaoLoginButton), for: .touchUpInside)
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        self.view = onboardingView
        self.view.backgroundColor = .white
    }

    // MARK: - Actions
    
    @objc private func didTapLoginButton() {
        navigateToLoginView()
        print("Login button tapped")
    }
    
    @objc private func didTapKakaoLoginButton() {
        print("Kakao login button tapped")
        //handleKakaoLogin()
    }
    
    // MARK: - Navigation
    
    private func navigateToLoginView() {
        let view = LoginViewController()
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
    
    //TODO: - kakao login 구현 필요
}
