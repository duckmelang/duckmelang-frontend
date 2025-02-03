//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import Moya

class LoginViewController: UIViewController {
    
    private let provider = MoyaProvider<AllEndpoint>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        
        loginView.emailTextField.addTarget(self, action: #selector(textFieldsUpdated),for: .editingChanged)
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
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.pwdTextField.text, !password.isEmpty else {
            showErrorAlert(message: "이메일과 비밀번호를 입력하세요.")
            return
        }

        print("📡 로그인 시도: \(email), \(password)")

        var requestFailed = false

        // 5초 후 타임아웃 처리 (응답이 오면 취소됨)
        let timeoutWorkItem = DispatchWorkItem {
            DispatchQueue.main.async {
                requestFailed = true
                self.showErrorAlert(message: "서버 응답이 지연되고 있습니다.\n잠시 후 다시 시도해주세요.")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: timeoutWorkItem)

        provider.request(.login(email: email, password: password)) { result in
            timeoutWorkItem.cancel()  // 응답이 오면 타임아웃 취소
            print("⌛️ timeout canceled")
            
            if requestFailed { return } // 타임아웃이 이미 실행된 경우 무시

            switch result {
            case .success:
                // 성공한 경우에만 홈 화면 이동 (오류는 MoyaLoggerPlugin에서 처리)
                DispatchQueue.main.async {
                    self.navigateToHomeView()
                }

            case .failure:
                // ❗️ MoyaLoggerPlugin이 자동으로 오류 핸들링하므로 여기서는 처리하지 않음
                break
            }
        }
    }
    
    @objc private func textFieldsUpdated() {
        let isUsernameValid = !(
            loginView.emailTextField.text?.isEmpty ?? true
        )
        let isPasswordValid = !(
            loginView.pwdTextField.text?.isEmpty ?? true
        )

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
