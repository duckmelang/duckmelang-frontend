//
//  OnBoardingViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SafariServices
import KakaoSDKCommon
import KakaoSDKUser

class OnBoardingViewController: UIViewController {
    let networkService = LoginService()
    
    var memberId: Int?
    
    // MARK: - Properties
    
    private lazy var onboardingView: OnBoardingView = {
        let view = OnBoardingView()
        view.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        view.kakaoLoginButton.addTarget(self, action: #selector(didTapKakaoLoginButton), for: .touchUpInside)
//        view.googleLoginButton.addTarget(self, action: #selector(didTapGoogleLoginButton), for: .touchUpInside)
        view.phoneLoginButton.addTarget(self, action: #selector(didTapPhoneLoginButton), for: .touchUpInside)
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
//        MARK: SDK로 구현한 부분
//        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//            if let error = error {
//                print(error)
//            }
//            else if let oauthToken = oauthToken {
//                KeychainManager.shared.save(key: "accessToken", value: oauthToken.accessToken)
//                KeychainManager.shared.save(key: "refreshToken", value: oauthToken.refreshToken)
//            }
//        }
        
//        MARK: 인가코드 받는 방식
//        kakaoLoginManager.loginWithKakao { code in
//            if let code = code {
//                // 👉 code 받아서 서버에 전송하거나 Kakao에 token 요청
//                print("받은 code: \(code)")
//            } else {
//                print("code를 받지 못했습니다.")
//            }
//        }
    }
    
//    @objc private func didTapGoogleLoginButton() {
//        print("Google login button tapped")
//        openOAuthLogin(api: networkService.googleLogin)
//    }
//    
    @objc private func didTapPhoneLoginButton() {
        print("Phone Signin button tapped")
        navigateToPhoneSinginView()
    }

//    // OAuthWebViewController에서 로그인 후 받은 데이터를 처리
//    func handleOAuthResponse(memberId: Int, profileComplete: Bool) {
//        print("✅ OAuth 완료 - memberId: \(memberId), profileComplete: \(profileComplete)")
//        
//        // 🔥 로그인 후 자동 발급된 토큰 가져오기
//        guard let accessToken = KeychainManager.shared.load(key: "accessToken"),
//              let refreshToken = KeychainManager.shared.load(key: "refreshToken") else {
//            print("❌ 토큰 저장 실패 - 로그인 API에서 토큰을 저장하지 못했을 가능성 있음")
//            return
//        }
//
//        print("🔐 로그인 완료 - Access Token: \(accessToken.prefix(10))..., Refresh Token: \(refreshToken.prefix(10))...")
//
//        // 모달을 닫고 처리 후 화면 전환
//        dismiss(animated: true) {
//            if profileComplete {
//                // 프로필이 완료된 경우 BaseViewController로 이동
//                self.navigateToBaseViewController()
//            } else {
//                // 프로필이 완료되지 않은 경우 MakeProfilesViewController로 이동
//                self.navigateToMakeProfilesViewController(memberId: memberId)
//            }
//        }
//    }
//
    private func navigateToBaseViewController() {
        let baseVC = BaseViewController()
        baseVC.modalPresentationStyle = .fullScreen
        present(baseVC, animated: true)
    }
//
//
//    private func navigateToMakeProfilesViewController(memberId: Int) {
//        let makeProfilesVC = MakeProfilesViewController(memberId: memberId)
//        let navigationController = UINavigationController(rootViewController: makeProfilesVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        // 모달을 닫고 네비게이션 방식으로 화면을 이동
//        self.present(navigationController, animated: true)
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
}
