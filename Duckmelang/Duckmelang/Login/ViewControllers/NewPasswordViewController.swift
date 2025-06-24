//
//  NewPasswordViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/23/25.
//

import UIKit

class NewPasswordViewController: UIViewController {
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
    
    @objc func didTapVerifyButton(_ textField: UITextField) {
        // MARK: 테스트를 위한 임시 구문
        let completeVC = CompleteResetPasswordViewController()
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        // 버튼은 빈 문자열일 땐 무조건 비활성화
        newPasswordView.verifyButton.setEnabled(!text.isEmpty)

        // 비밀번호 유효성 검사
        if isValidPassword(text) {
            newPasswordView.alertLabel.isHidden = true
            newPasswordView.verifyButton.isEnabled = true
            newPasswordView.verifyButton.alpha = 1.0
            textField.layer.borderColor = UIColor.grey400!.cgColor
        } else {
            newPasswordView.alertLabel.isHidden = false
            newPasswordView.verifyButton.isEnabled = false
            newPasswordView.verifyButton.alpha = 0.5
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    // 영문 + 숫자 조합, 8자 이상인지 확인
    func isValidPassword(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}
