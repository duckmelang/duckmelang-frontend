//
//  SignUpViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit

class SignUpViewController: UIViewController {
    let networkService = SignupService()
    
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
        return view
    }()
    
    @objc private func didTapSigninButton() {
        guard let email = signupView.emailTextField.text, !email.isEmpty,
              let password = signupView.pwTextField.text, !password.isEmpty else {
            print("이메일 또는 비밀번호를 입력하세요.")
            return
        }
        
        signUp(email: email, password: password)
        print("goto MakeProfile : \(email), \(password)")
    }
        
    private func signUp(email: String, password: String) {
        Task {
            do {
                startLoading()
                
                let newSignupRequest = SignupRequest(email: email, password: password)
                let result = try await networkService.postSignUp(signUp: newSignupRequest)
                
                let memberId = result.memberId
                let profileComplete = result.profileComplete
                
                if !profileComplete {
                    DispatchQueue.main.async {
                        self.navigateToMakeProfileView(memberId: memberId)
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
    
    private func navigateToMakeProfileView(memberId: Int) {
        let splashViewController = AuthSuccessSplashViewController()
        splashViewController.modalPresentationStyle = .fullScreen
        splashViewController.modalTransitionStyle = .crossDissolve
        if let window = view.window {
            window.rootViewController = splashViewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { _ in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    let makeProfilesVC = MakeProfilesViewController()
//                    let navigationController = UINavigationController(rootViewController: makeProfilesVC)
//                    navigationController.modalPresentationStyle = .fullScreen
//                    window.rootViewController = navigationController
//                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
//                }
            }
        }
    }
}
