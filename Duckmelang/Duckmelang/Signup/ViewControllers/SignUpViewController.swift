//
//  SignUpViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit

class SignUpViewController: UIViewController {
    let networkService = SignupService()
    
    var memberId: Int?
    private var isIDVerified: Bool = false {
        didSet {
            signupView.successLabel.isHidden = !isIDVerified
            pwTextFieldsDidChange()
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
    
    @objc private func didTapSigninButton() {
        guard let email = signupView.idTextField.text, !email.isEmpty,
              let password = signupView.pwTextField.text, !password.isEmpty else { return }
        
//        signUp(email: email, password: password)
        navigateToMakeProfileView()
        print("goto MakeProfile : \(email), \(password)")
    }
    
    @objc func idTextFieldsDidChange() {
        // 만약 인증된 상태라면 → 초기화
        if isIDVerified {
            isIDVerified = false
        }
        
        let textCount = signupView.idTextField.text?.count ?? 0
        signupView.idButton.isEnabled = textCount >= 3
    }
    
    @objc func pwTextFieldsDidChange() {
        let isPasswordNotEmpty = !(signupView.pwTextField.text?.isEmpty ?? true)
        let canEnableSignup = isIDVerified && isPasswordNotEmpty
        signupView.signUpButton.setEnabled(canEnableSignup)
    }
    
    @objc func didTapIdButton() {
        // 중복확인 API 호출하고 error message띄우던가 아니면 아래처럼
        isIDVerified = true
        signupView.idButton.isEnabled = false
    }
        
    private func signUp(email: String, password: String) {
        Task {
            do {
                startLoading()
                
                let newSignupRequest = SignupRequest(email: email, password: password)
                let result = try await networkService.postSignUp(signUp: newSignupRequest)
                
                self.memberId = result.memberId
                let profileComplete = result.profileComplete
                
                if !profileComplete {
                    DispatchQueue.main.async {
                        self.navigateToMakeProfileView()
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
        splashVC.memberId = self.memberId
        self.present(splashVC, animated: true)
    }
}
