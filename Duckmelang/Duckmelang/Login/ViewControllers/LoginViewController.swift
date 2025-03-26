//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import Moya

class LoginViewController: UIViewController, MoyaErrorHandlerDelegate {
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
    
    
    lazy var provider: MoyaProvider<LoginAPI> = {
            return MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
        }()
    
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

        print("📡 로그인 시도: \(email), \(password)")

        provider.request(.postLogin(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    
                    // ✅ JSON 디코딩 (오류가 발생하면 catch 블록으로 이동)
                    let loginResponse = try decoder.decode(LoginResponse.self, from: response.data)

                    // ✅ JSON 디코딩 성공한 경우만 로그 출력
                    print("📩 서버 응답 JSON (Decoded): \(loginResponse)")

                    if loginResponse.isSuccess {
                        print("✅ 로그인 성공: \(loginResponse.message)")
                        // 🔥 ✅ 토큰 저장
                        let loginResult = loginResponse.result
                        KeychainManager.shared.save(key: "accessToken", value: loginResult.accessToken)
                        KeychainManager.shared.save(key: "refreshToken", value: loginResult.refreshToken)
                        KeychainManager.shared.save(key: "memberId", value: String(loginResult.memberId))

                        print("🔑 Access Token 저장 완료: \(loginResult.accessToken.prefix(10))...")
                        print("🔑 Refresh Token 저장 완료: \(loginResult.refreshToken.prefix(10))...")

                        DispatchQueue.main.async {
                            self.navigateToHomeView()
                        }
                    } else {
                        print("⚠️ 로그인 실패: \(loginResponse.message)")
                        DispatchQueue.main.async {
                            self.showAlert(title: "로그인 실패", message: loginResponse.message)
                        }
                    }

                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "오류", message: "서버 응답을 처리하는 중 오류가 발생했습니다.")
                    }
                    return
                }

            case .failure(let error):
                print("❌ 로그인 요청 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "오류", message: "네트워크 오류가 발생했습니다. 다시 시도해 주세요.")
                }
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
