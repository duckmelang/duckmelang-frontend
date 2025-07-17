//
//  OnBoardingViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/14/25.
//

import UIKit
import SafariServices
import KakaoSDKCommon
import KakaoSDKUser
import SwiftyToaster

class OnBoardingViewController: UIViewController {
    let networkService = LoginService()
    
    // MARK: - Properties
    
    private lazy var onboardingView: OnBoardingView = {
        let view = OnBoardingView()
        view.kakaoLoginButton.addTarget(self, action: #selector(didTapKakaoLoginButton), for: .touchUpInside)
        view.phoneLoginButton.addTarget(self, action: #selector(didTapPhoneLoginButton), for: .touchUpInside)
        view.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
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
        print("GoTo Login")
        navigateToLoginView()
    }
    
    @objc private func didTapKakaoLoginButton() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 인증
            kakaoLoginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
    
    private func kakaoLoginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else if let oauthToken = oauthToken {
                self.kakaoLogin(accessToken: oauthToken.accessToken)
            } else {
                Toaster.shared.makeToast("소셜 로그인에 실패했습니다. 잠시 후 다시 시도해 주세요.")
            }
        }
    }
    
    private func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else if let oauthToken = oauthToken {
                self.kakaoLogin(accessToken: oauthToken.accessToken)
            } else {
                Toaster.shared.makeToast("소셜 로그인에 실패했습니다. 잠시 후 다시 시도해 주세요.")
            }
        }
    }
        
    @objc private func didTapPhoneLoginButton() {
        print("Phone Signin button tapped")
        navigateToPhoneSigninView()
    }
    
    // MARK: - API
    
    private func kakaoLogin(accessToken: String) {
        Task {
            do {
                startLoading()
                
                let newRequest = KakaoLoginRequest(accessToken: accessToken)
                let result = try await networkService.kakaoLogin(accessToken: newRequest)
                
                KeychainManager.shared.save(key: "accessToken", value: result.accessToken)
                KeychainManager.shared.save(key: "refreshToken", value: result.refreshToken)
                KeychainManager.shared.save(key: "memberId", value: String(result.memberId))
                
                if result.profileComplete {
                    // 프로필 설정이 완료된 경우
                    DispatchQueue.main.async {
                        self.navigateToBaseViewController()
                        
                        Toaster.shared.makeToast("성공적으로 로그인되었습니다.")
                    }
                } else {
                    // 프로필 설정이 미완료된 경우
                    DispatchQueue.main.async {
                        self.navigateToMakeProfileView()
                        
                        Toaster.shared.makeToast("성공적으로 로그인되었습니다. \n 프로필 설정이 완료되지 않아 프로필 설정 화면으로 이동합니다.")
                    }
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("로그인에 실패했습니다. 잠시 후 다시 시도해 주세요.")
            }
        }
    }
    
    // MARK: - Navigation
    
    private func navigateToBaseViewController() {
        let baseVC = BaseViewController()
        baseVC.modalPresentationStyle = .fullScreen
        present(baseVC, animated: true)
    }
    
    private func navigateToMakeProfileView() {
        let mainVC = ProfileSplashViewController()
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        present(mainVC, animated: true)
    }
    
    private func navigateToLoginView() {
        let view = LoginViewController()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    private func navigateToPhoneSigninView() {
        let view = PhoneSigninViewController()
        self.navigationController?.pushViewController(view, animated: true)
    }
}
