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
            showErrorPopup(message: "이메일과 비밀번호를 입력하세요.")
            return
        }

        print("로그인 시도: \(email), \(password)")

        var requestFailed = false  // 타임아웃이 발생했는지 체크

        // 5초 후 타임아웃 팝업을 띄우고 `case .failure` 실행
        let timeoutWorkItem = DispatchWorkItem {
            DispatchQueue.main.async {
                requestFailed = true
                self.showErrorPopup(message: "로그인 실패하였습니다.\n다시 시도해주세요.")
            }
        }

        // 5초 후 실행 (만약 응답이 오면 취소됨)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: timeoutWorkItem)

        provider.request(.login(email: email, password: password)) { result in
            timeoutWorkItem.cancel() // 응답이 오면 타임아웃 작업 취소

            // 타임아웃이 발생한 경우, 실패 처리로 바로 이동
            if requestFailed {
                print("⏳ 타임아웃 발생 → 로그인 실패 처리")
                return
            }

            switch result {
            case .success(let response):
                print("로그인 성공: \(response)")
                DispatchQueue.main.async {
                    self.navigateToHomeView()
                }
            case .failure(let error):
                print("로그인 실패: \(error)")
                DispatchQueue.main.async {
                    self.showErrorPopup(message: "로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.")
                }
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
    
    private func showErrorPopup(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(confirmAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
