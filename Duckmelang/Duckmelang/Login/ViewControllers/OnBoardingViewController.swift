//
//  OnBoardingViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import Moya
import SafariServices
import Alamofire

class OnBoardingViewController: UIViewController, SFSafariViewControllerDelegate, MoyaErrorHandlerDelegate {
    private lazy var provider = MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
    

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
        print("GoTo Login")
    }
    
    @objc private func didTapKakaoLoginButton() {
        print("Kakao login button tapped")
        openOAuthLogin(urlString: "\(API.oauthURL)/kakao")
    }
    
    @objc private func didTapGoogleLoginButton() {
        print("Google login button tapped")
        openOAuthLogin(urlString: "\(API.oauthURL)/google")
    }
    
    @objc private func didTapPhoneLoginButton() {
        print("Phone Signin button tapped")
        navigateToPhoneSinginView()
    }
    
    // MARK: - OAuth 로그인 처리
        private func openOAuthLogin(urlString: String) {
            guard let url = URL(string: urlString) else {
                print("OAuth 로그인 URL이 잘못되었습니다.")
                return
            }
    
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            safariVC.delegate = self
    
            present(safariVC, animated: true, completion: nil)
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            print("Safari 창 닫힘")
            dismiss(animated: true, completion: nil)
        }
    
    // Safari를 사용한 OAuth 로그인 진행
    private func openOAuthLogin(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        safariVC.delegate = self

        present(safariVC, animated: true, completion: nil)
    }
    
    // MARK: - MoyaErrorHandlerDelegate 구현
    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "오류 발생",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    private func navigateToLoginView() {
        let view = LoginViewController()
        self.navigationController?.pushViewController(view, animated: true)

    }
    
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
