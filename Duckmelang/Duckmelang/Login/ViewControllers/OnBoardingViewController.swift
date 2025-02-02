//
//  OnBoardingViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import Moya
import SafariServices

class OnBoardingViewController: UIViewController, SFSafariViewControllerDelegate {
    private let provider = MoyaProvider<AllEndpoint>()

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
//        loginWithKakao()
        //FIXME: - 테스트용 : 삭제필요
        openOAuthLogin(urlString: "https://rladusdn02.notion.site/kakaooath?pvs=4")
    }
    
    @objc private func didTapGoogleLoginButton() {
        print("Google login button tapped")
//        loginWithGoogle()
        //FIXME: - 테스트용 : 삭제필요
        openOAuthLogin(urlString: "https://rladusdn02.notion.site/googleoath?pvs=4")
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

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        safariVC.delegate = self

        present(safariVC, animated: true, completion: nil)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("✅ Safari 창 닫힘")
        dismiss(animated: true, completion: nil)
    }

        
//    private func loginWithKakao() {
//        provider.request(.kakaoLogin) { result in
//            switch result {
//            case .success(let response):
//                if let loginURL = try? response.mapString(), let url = URL(string: loginURL) {
//                    DispatchQueue.main.async {
//                        let oauthVC = OAuthLoginViewController(url: url)
//                        oauthVC.modalPresentationStyle = .fullScreen
//                        self.present(oauthVC, animated: true)
//                    }
//                } else {
//                    print("Kakao 로그인 URL을 가져오지 못했습니다.")
//                }
//            case .failure(let error):
//                print("Kakao 로그인 요청 실패: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func loginWithGoogle() {
//        provider.request(.googleLogin) { result in
//            switch result {
//            case .success(let response):
//                if let loginURL = try? response.mapString(), let url = URL(string: loginURL) {
//                    DispatchQueue.main.async {
//                        let oauthVC = OAuthLoginViewController(url: url)
//                        oauthVC.modalPresentationStyle = .fullScreen
//                        self.present(oauthVC, animated: true)
//                    }
//                } else {
//                    print("Google 로그인 URL을 가져오지 못했습니다.")
//                }
//            case .failure(let error):
//                print("Google 로그인 요청 실패: \(error.localizedDescription)")
//            }
//        }
//    }

    
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
