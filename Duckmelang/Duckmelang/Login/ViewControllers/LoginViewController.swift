//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import Moya

class LoginViewController: UIViewController, MoyaErrorHandlerDelegate {
    
    private lazy var provider: MoyaProvider<LoginAPI> = {
        let loggerPlugin = MoyaLoggerPlugin(delegate: self)
        print("✅ MoyaLoggerPlugin 추가됨!")
        let provider = MoyaProvider<LoginAPI>(plugins: [loggerPlugin])
        print("🛠 provider.plugins: \(provider.plugins)")
        return provider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        
        loginView.emailTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
        loginView.pwdTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
    }
    
    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.loginButton
            .addTarget(
                self,
                action: #selector(didTapLoginButton),
                for: .touchUpInside
            )
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white!
            
        self.navigationItem.title = "로그인"
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
    
    private func navigateToHomeView() {
        let mainVC = BaseViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
        
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapLoginButton() {
        print("🔘 Login button tapped")

        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.pwdTextField.text, !password.isEmpty else {
            print("🚨 입력값 없음 - 로그인 요청 중단")
            showErrorAlert(message: "이메일과 비밀번호를 입력하세요.")
            return
        }

        // ✅ 네트워크 상태 체크: 네트워크 상태가 변경된 후에만 확인하도록 변경
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusChange), name: .networkStatusChanged, object: nil)

        print("📡 로그인 시도: \(email), \(password)")

        // ✅ 타임아웃 감지 시작
        NetworkMonitor.shared.startRequestTimeout(target: LoginAPI.postLogin(email: email, password: password)) {
            self.showErrorAlert(message: "서버 응답이 없습니다.\n네트워크 상태를 확인하세요.")
        }

        provider.request(.postLogin(email: email, password: password)) { result in
            NetworkMonitor.shared.cancelRequestTimeout(target: LoginAPI.postLogin(email: email, password: password))

            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("✅ 로그인 성공")
                    self.navigateToHomeView()
                }
            case .failure(let error):
                print("❌ 로그인 요청 실패: \(error.localizedDescription)")
                
                // 네트워크 연결 실패 시 더 간단한 메시지로 사용자에게 안내
                let errorMessage = error.localizedDescription.contains("Could not connect to the server") ?
                    "서버에 연결할 수 없습니다. \n네트워크 상태를 확인하세요." :
                    "로그인 실패: \(error.localizedDescription)"
                    
                self.showErrorAlert(message: errorMessage)
            }
        }
    }
    // 네트워크 상태 변경 시 호출되는 메서드
    @objc private func handleNetworkStatusChange(notification: Notification) {
        // 네트워크 상태가 연결되지 않은 경우에만 경고 메시지 출력
        if let isConnected = notification.object as? Bool, !isConnected {
            print("🚨 네트워크 연결 없음 - 로그인 요청 중단")
            showErrorAlert(message: "인터넷 연결이 없습니다.\n네트워크 상태를 확인하세요.")
        }
        
        // 첫 번째 네트워크 상태 변경 후 옵저버 제거
        NotificationCenter.default.removeObserver(self, name: .networkStatusChanged, object: nil)
    }
    
    @objc private func textFieldsUpdated() {
        let isUsernameValid = !(loginView.emailTextField.text?.isEmpty ?? true)
        let isPasswordValid = !(loginView.pwdTextField.text?.isEmpty ?? true)

        loginView.loginButton.isEnabled = isUsernameValid && isPasswordValid
        loginView.loginButton.alpha = isUsernameValid && isPasswordValid ? 1.0 : 0.5
    }
    
    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "오류 발생",
                message: message,
                preferredStyle: .alert
            )
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirmAction)

            // 중복 팝업 방지
            if self.presentedViewController == nil {
                self.present(alert, animated: true)
            }
        }
    }
}
