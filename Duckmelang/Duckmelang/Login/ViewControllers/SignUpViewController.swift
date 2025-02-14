//
//  SignUpViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Moya

class SignUpViewController: UIViewController, MoyaErrorHandlerDelegate {
    // MARK: - 오류 처리 (Alert)
    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirmAction)
            alert.view.tintColor = UIColor.red
            self.present(alert, animated: true)
        }
    }
    
    
    lazy var provider: MoyaProvider<LoginAPI> = {
            return MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
        }()
    
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
            print("ID 또는 비밀번호를 입력하세요.")
            return
        }
        
        signUp(email: email, password: password)
        print("goto MakeProfile : \(email), \(password)")
    }
    
    private func signUp(email: String, password: String) {
        // 5초 후 타임아웃 팝업을 띄우기 위한 DispatchWorkItem 설정
        let timeoutWorkItem = DispatchWorkItem {
            DispatchQueue.main.async {
                self.showErrorPopup(message: "요청 시간이 초과되었습니다. 다시 시도해주세요.")
            }
        }
        // 5초 후 실행 (만약 응답이 오면 취소됨)
        DispatchQueue.main
            .asyncAfter(deadline: .now() + 5, execute: timeoutWorkItem)
        
        provider.request(.postSignUp(email: email, password: password)) { result in
            timeoutWorkItem.cancel()
            switch result {
            case .success(let response):
                if response.statusCode == 201 {
                    print("회원가입 성공")
                    self.navigateToMakeProfileView()
                } else {
                    print("회원가입 실패: \(response.statusCode)")
                }
            case .failure(let error):
                print("오류: \(error), \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorPopup(message: "회원가입에 실패했습니다. 다시 시도해주세요.")
                }
            }
        }
    }
    private func navigateToMakeProfileView() {
        let view = MakeProfilesViewController()
        self.navigationController?.pushViewController(view, animated: true)
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
