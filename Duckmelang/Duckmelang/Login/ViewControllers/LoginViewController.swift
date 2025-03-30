//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit

class LoginViewController: UIViewController {
    let networkService = LoginService()
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        
        loginView.emailTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
        loginView.pwdTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
        
        loginView.foundPWBtn.addTarget(self, action: #selector(goVerifyView), for: .touchUpInside)
    }
    
    private lazy var loginView: LoginView = {
        let view = LoginView()
        
        view.loginButton.alpha = 0.5
        
        view.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
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
    
    @objc private func goVerifyView() {
        let verifyVC = VerifyPhoneViewController()
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    @objc private func didTapLoginButton() {
        print("🔘 Login button tapped")

        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.pwdTextField.text, !password.isEmpty else {
            print("🚨 입력값 없음 - 로그인 요청 중단")
            showAlert(title: "확인필요", message: "이메일과 비밀번호를 입력하세요.")
            return
        }
        
        postLoginAPI(email: email, password: password)
    }
    
    private func postLoginAPI(email: String, password: String) {
        Task {
            do {
                startLoading()
                
                let newLoginRequest = LoginRequest(email: email, password: password)
                let result = try await networkService.postLogin(login: newLoginRequest)
                
                KeychainManager.shared.save(key: "accessToken", value: result.accessToken)
                KeychainManager.shared.save(key: "refreshToken", value: result.refreshToken)
                KeychainManager.shared.save(key: "memberId", value: String(result.memberId))
                
                DispatchQueue.main.async {
                    self.navigateToHomeView()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func textFieldsUpdated() {
        let isUsernameValid = !(loginView.emailTextField.text?.isEmpty ?? true)
        let isPasswordValid = !(loginView.pwdTextField.text?.isEmpty ?? true)

        loginView.loginButton.isEnabled = isUsernameValid && isPasswordValid
        loginView.loginButton.alpha = isUsernameValid && isPasswordValid ? 1.0 : 0.5
    }
}
