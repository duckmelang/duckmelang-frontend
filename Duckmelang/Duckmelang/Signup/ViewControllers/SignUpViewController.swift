//
//  SignUpViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit

class SignUpViewController: UIViewController {
    let networkService = SignupService()
    
    private var isIDVerified: Bool = false {
        didSet {
            signupView.successLabel.isHidden = !isIDVerified
            checkSignupButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = signupView
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "회원가입"
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
    
    // MARK: - Properties
    private lazy var signupView: SignUpView = {
        let view = SignUpView()
        view.signUpButton.addTarget(self, action: #selector(didTapSigninButton), for: .touchUpInside)
        view.idTextField.addTarget(self, action: #selector(idTextFieldsDidChange), for: .editingChanged)
        view.idButton.addTarget(self, action: #selector(didTapIdButton), for: .touchUpInside)
        view.pwTextField.addTarget(self, action: #selector(pwTextFieldsDidChange), for: .editingChanged)
        return view
    }()
    
    @objc func idTextFieldsDidChange() {
        // 만약 인증된 상태라면 → 초기화
        if isIDVerified {
            isIDVerified = false
        }
        
        // 만약 에러 상태라면 → 에러 상태 해제
        if signupView.idTextField.isInErrorState {
            signupView.idTextField.setErrorState(false)
            signupView.idAlertLabel.isHidden = true
        }
        
        let textCount = signupView.idTextField.text?.count ?? 0
        signupView.idButton.isEnabled = textCount >= 3
    }
    
    @objc func pwTextFieldsDidChange() {
        let text = signupView.pwTextField.text ?? ""
        
        // 비밀번호 유효성 검사
        if isValidPassword(text) {
            signupView.pwAlertLabel.isHidden = true
            signupView.signUpButton.setEnabled(isIDVerified)
            signupView.pwTextField.setErrorState(false)
        } else {
            signupView.pwAlertLabel.isHidden = false
            signupView.signUpButton.setEnabled(false)
            signupView.pwTextField.setErrorState(true)
        }
    }
    
    private func checkSignupButton() {
        let text = signupView.pwTextField.text ?? ""
        let canEnableSignup = isIDVerified && isValidPassword(text)
        signupView.signUpButton.setEnabled(canEnableSignup)
    }
    
    @objc func didTapIdButton() {
        guard let loginId = signupView.idTextField.text else { return }
        getCheckNicknameAPI(loginId: loginId)
    }
    
    // 아이디 중복 확인 API
    private func getCheckNicknameAPI(loginId: String) {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getCheckNickname(loginId: loginId)
                
                if result.isDuplicate {
                    DispatchQueue.main.async {
                        self.isIDVerified = false
                        self.signupView.idAlertLabel.isHidden = false
                        self.signupView.idTextField.setErrorState(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isIDVerified = true
                    }
                }
                self.signupView.idButton.isEnabled = false
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    // 아이디/비번 텍스트가 비어있지 않으면, 회원가입 API 호출
    @objc private func didTapSigninButton() {
        guard let loginId = signupView.idTextField.text, !loginId.isEmpty,
              let password = signupView.pwTextField.text, !password.isEmpty else { return }
        
        signUp(loginId: loginId, password: password)
    }
       
    // 회원가입 API
    private func signUp(loginId: String, password: String) {
        Task {
            do {
                startLoading()
                
                let newSignupRequest = SignupRequest(loginId: loginId, password: password)
                let result = try await networkService.postSignUp(signUp: newSignupRequest)
                
//                KeychainManager.shared.save(key: "accessToken", value: result.accessToken)
//                KeychainManager.shared.save(key: "refreshToken", value: result.refreshToken)
                KeychainManager.shared.save(key: "memberId", value: String(result.memberId))
                
                if !result.profileComplete {
                    DispatchQueue.main.async {
                        self.navigateToMakeProfileView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigateToBaseView()
                    }
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func navigateToMakeProfileView() {
        let splashVC = AuthSuccessSplashViewController()
        splashVC.modalPresentationStyle = .fullScreen
        splashVC.modalTransitionStyle = .crossDissolve
        self.present(splashVC, animated: true)
    }
    
    private func navigateToBaseView() {
        let baseVC = BaseViewController()
        baseVC.modalPresentationStyle = .fullScreen
        baseVC.modalTransitionStyle = .crossDissolve
        self.present(baseVC, animated: true)
    }
}
