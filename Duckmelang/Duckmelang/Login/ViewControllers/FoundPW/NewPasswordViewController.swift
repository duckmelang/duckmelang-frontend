//
//  NewPasswordViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/23/25.
//

import UIKit
import SwiftyToaster

class NewPasswordViewController: UIViewController {
    let networkService = LoginService()
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = newPasswordView
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var newPasswordView: NewPasswordView = {
        let view = NewPasswordView()
        view.verifyButton.addTarget(self, action: #selector(didTapVerifyButton), for: .touchUpInside)
        view.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationItem.title = "비밀번호 찾기"
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
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        // 비밀번호 유효성 검사
        if isValidPassword(text) {
            newPasswordView.alertLabel.isHidden = true
            newPasswordView.verifyButton.isEnabled = true
            newPasswordView.passwordTextField.setErrorState(false)
        } else {
            newPasswordView.alertLabel.isHidden = false
            newPasswordView.verifyButton.isEnabled = false
            newPasswordView.passwordTextField.setErrorState(true)
        }
    }
    
    @objc func didTapVerifyButton() {
        guard let password = newPasswordView.passwordTextField.text else { return }
        patchPasswordAPI(loginId: self.id, password: password)
    }
    
    // 비밀번호 변경 API 호출
    private func patchPasswordAPI(loginId: String, password: String) {
        Task {
            do {
                startLoading()
                
                let newLoginRequest = NewPasswordRequest(loginId: loginId, newPassword: password)
                _ = try await networkService.patchPassword(login: newLoginRequest)
                
                // 비밀번호 성공 시
                let completeVC = CompleteResetPasswordViewController()
                self.navigationController?.pushViewController(completeVC, animated: true)
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast(error.localizedDescription)
            }
        }
    }
}
