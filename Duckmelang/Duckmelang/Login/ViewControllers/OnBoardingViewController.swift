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

class OnBoardingViewController: UIViewController, MoyaErrorHandlerDelegate {
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
            print("❌ OAuth 로그인 URL이 잘못되었습니다.")
            return
        }

        let oauthWebVC = OAuthWebViewController()
        oauthWebVC.authURL = url
        oauthWebVC.modalPresentationStyle = .pageSheet
        // OAuthWebViewController에서 로그인 후 받은 데이터를 처리할 클로저 설정
        oauthWebVC.oauthCompletion = { [weak self] memberId, profileComplete in
            self?.handleOAuthResponse(memberId: memberId, profileComplete: profileComplete)
        }
        present(oauthWebVC, animated: true)
    }

    // OAuthWebViewController에서 로그인 후 받은 데이터를 처리
    func handleOAuthResponse(memberId: Int, profileComplete: Bool) {
        print("✅ OAuth 처리 완료 - memberId: \(memberId), profileComplete: \(profileComplete)")

        // 모달을 닫고 처리 후 화면 전환
        dismiss(animated: true) {
            if profileComplete {
                // 프로필이 완료된 경우 BaseViewController로 이동
                self.navigateToBaseViewController()
            } else {
                // 프로필이 완료되지 않은 경우 MakeProfilesViewController로 이동
                self.navigateToMakeProfilesViewController()
            }
        }
    }

    private func navigateToBaseViewController() {
        let baseVC = BaseViewController()
        baseVC.modalPresentationStyle = .fullScreen
        present(baseVC, animated: true)
    }

    private func navigateToMakeProfilesViewController() {
        let makeProfilesVC = MakeProfilesViewController()
        let navigationController = UINavigationController(rootViewController: makeProfilesVC)
        navigationController.modalPresentationStyle = .fullScreen
        // 모달을 닫고 네비게이션 방식으로 화면을 이동
        self.present(navigationController, animated: true)
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
        navigateToBaseViewController()
    }
}
