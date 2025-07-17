//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SwiftyToaster

class LoginViewController: UIViewController, UITextFieldDelegate {
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
        
        loginView.idTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
        loginView.pwdTextField.addTarget(self, action: #selector(textFieldsUpdated), for: .editingChanged)
        
        loginView.foundIDBtn.addTarget(self, action: #selector(foundIDBtnTap), for: .touchUpInside)
        loginView.foundPWBtn.addTarget(self, action: #selector(foundPWBtnTap), for: .touchUpInside)
    }
    
    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.idTextField.delegate = self
        view.pwdTextField.delegate = self
        
        view.loginButton.setEnabled(false)
        
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
        
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func foundIDBtnTap() {
        let verifyVC = VerifyPhoneViewController()
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    @objc private func foundPWBtnTap() {
        let foundPWVC = FoundPasswordViewController()
        self.navigationController?.pushViewController(foundPWVC, animated: true)
    }
    
    
    @objc private func didTapLoginButton() {
        print("🔘 Login button tapped")

        guard let id = loginView.idTextField.text, !id.isEmpty,
              let password = loginView.pwdTextField.text, !password.isEmpty else {
            print("🚨 입력값 없음 - 로그인 요청 중단")
            showAlert(title: "확인필요", message: "이메일과 비밀번호를 입력하세요.")
            return
        }
        
        postLoginAPI(id: id, password: password)
    }
    
    private func postLoginAPI(id: String, password: String) {
        Task {
            do {
                startLoading()
                
                let newLoginRequest = LoginRequest(loginId: id, password: password)
                let result = try await networkService.postLogin(login: newLoginRequest)
                
                KeychainManager.shared.save(key: "accessToken", value: result.accessToken)
                KeychainManager.shared.save(key: "refreshToken", value: result.refreshToken)
                KeychainManager.shared.save(key: "memberId", value: String(result.memberId))
                
                if result.profileComplete {
                    // 프로필 설정이 완료된 경우
                    DispatchQueue.main.async {
                        self.navigateToHomeView()
                        
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
                Toaster.shared.makeToast("로그인에 실패했습니다. 다시 시도해 주세요.")
            }
        }
    }
    
    private func navigateToHomeView() {
        let mainVC = BaseViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    
    private func navigateToMakeProfileView() {
        let mainVC = ProfileSplashViewController()
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        present(mainVC, animated: true)
    }
    
    @objc private func textFieldsUpdated() {
        let isUsernameValid = !(loginView.idTextField.text?.isEmpty ?? true)
        let isPasswordValid = !(loginView.pwdTextField.text?.isEmpty ?? true)

        loginView.loginButton.setEnabled(isUsernameValid && isPasswordValid)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapLoginButton()
        textField.resignFirstResponder()
        return true
    }
}
