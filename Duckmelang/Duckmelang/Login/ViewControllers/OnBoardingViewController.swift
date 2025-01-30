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
        view.googleLoginButton.addTarget(self, action: #selector(didTapGoogleLoginButton), for: .touchUpInside)
        view.phoneLoginButton.addTarget(self, action: #selector(didTapPhoneLoginButton), for: .touchUpInside)
        
        //FIXME: - 개발 종료 후 지울것1. Main으로 연결되는 통로
        view.goHome.addTarget(self, action: #selector(didTapGoHome), for: .touchUpInside)
        
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
    
    @objc private func didTapGoogleLoginButton() {
        print("Google login button tapped")
        //handleGoogleLogin()
    }
    
    @objc private func didTapPhoneLoginButton() {
        print("Phone Signin button tapped")
        navigateToPhoneSinginView()
    }
    
    // MARK: - Navigation
    
    private func navigateToLoginView() {
        let view = LoginViewController()
        self.navigationController?.pushViewController(view, animated: true)

    }
    //TODO: - Kakao Login, Google Login 구현
    
    private func navigateToPhoneSinginView() {
        let view = PhoneSigninViewController()
        self.navigationController?.pushViewController(view, animated: true)

    }
    
    //FIXME: - 개발 종료 후 지울것2. Main으로 연결되는 통로
    @objc private func didTapGoHome() {
        print("go home")
        navigateToHomeView()
    }
    
    private func navigateToHomeView() {
        let mainVC = BaseViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}
