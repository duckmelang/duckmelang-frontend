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
    private lazy var provider: MoyaProvider<AllEndpoint> = {
        let loggerPlugin = MoyaLoggerPlugin(delegate: self)
        return MoyaProvider<AllEndpoint>(plugins: [loggerPlugin])
    }()

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
        checkInitialNetworkStatus()
        setupNetworkObserver()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        self.view = onboardingView
        self.view.backgroundColor = .white
    }
    // MARK: - 네트워크 상태 확인
    private func checkInitialNetworkStatus() {
        // 네트워크 상태가 처음 변경될 때까지 대기
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusChange), name: .networkStatusChanged, object: nil)
    }

    // 네트워크 상태 변경 시 호출되는 메서드
    @objc private func handleNetworkStatusChange(notification: Notification) {
        // 네트워크 상태가 연결되지 않은 경우에만 경고 메시지 출력
        if let isConnected = notification.object as? Bool, !isConnected {
            showErrorAlert(message: "인터넷 연결이 없습니다.\n네트워크 상태를 확인하세요.")
        }
        
        // 첫 번째 네트워크 상태 변경 후 옵저버 제거
        NotificationCenter.default.removeObserver(self, name: .networkStatusChanged, object: nil)
    }

       private func setupNetworkObserver() {
           NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .networkStatusChanged, object: nil)
       }

       @objc private func networkStatusChanged(_ notification: Notification) {
           if let isConnected = notification.object as? Bool {
               if isConnected {
                   print("✅ 네트워크 연결됨")
               } else {
                   showErrorAlert(message: "네트워크 연결이 끊어졌습니다.\n다시 확인해주세요.")
               }
           }
       }

       deinit {
           NotificationCenter.default.removeObserver(self)
       }

    // MARK: - Actions
    
    @objc private func didTapLoginButton() {
        navigateToLoginView()
        print("GoTo Login")
    }
    
    @objc private func didTapKakaoLoginButton() {
        print("Kakao login button tapped")
        requestOAuthURL(endpoint: .kakaoLogin)
        //FIXME: - 테스트용 : 삭제필요
        //openOAuthLogin(urlString: "https://rladusdn02.notion.site/kakaooath?pvs=4")
    }
    
    @objc private func didTapGoogleLoginButton() {
        print("Google login button tapped")
        requestOAuthURL(endpoint: .googleLogin)
        //FIXME: - 테스트용 : 삭제필요
        //openOAuthLogin(urlString: "https://rladusdn02.notion.site/googleoath?pvs=4")
    }
    
    @objc private func didTapPhoneLoginButton() {
        print("Phone Signin button tapped")
        navigateToPhoneSinginView()
    }
    
    // MARK: - OAuth 로그인 처리
    private func requestOAuthURL(endpoint: AllEndpoint) {
        provider.request(endpoint) { _ in
            // 오류는 MoyaLoggerPlugin에서 처리
        }
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

    // Safari를 사용한 OAuth 로그인 진행
    private func openOAuthLogin(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        safariVC.delegate = self

        present(safariVC, animated: true, completion: nil)
    }
    
//    //FIXME: - safari open Test
//    private func openOAuthLogin(urlString: String) {
//        guard let url = URL(string: urlString) else {
//            print("OAuth 로그인 URL이 잘못되었습니다.")
//            return
//        }
//
//        let safariVC = SFSafariViewController(url: url)
//        safariVC.modalPresentationStyle = .pageSheet
//        safariVC.delegate = self
//
//        present(safariVC, animated: true, completion: nil)
//    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Safari 창 닫힘")
        dismiss(animated: true, completion: nil)
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
