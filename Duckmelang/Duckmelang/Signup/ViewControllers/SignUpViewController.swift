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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = signupView
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
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
        view.emailTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        view.pwTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        return view
    }()
    
    @objc private func didTapSigninButton() {
        guard let email = signupView.emailTextField.text, !email.isEmpty,
              let password = signupView.pwTextField.text, !password.isEmpty else { return }
        
//        signUp(email: email, password: password)
        navigateToMakeProfileView()
        print("goto MakeProfile : \(email), \(password)")
    }
    
    @objc func textFieldsDidChange() {
        let text1 = signupView.emailTextField.text ?? ""
        let text2 = signupView.pwTextField.text ?? ""
        
        signupView.signUpButton.setEnabled(!text1.isEmpty && !text2.isEmpty)
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
