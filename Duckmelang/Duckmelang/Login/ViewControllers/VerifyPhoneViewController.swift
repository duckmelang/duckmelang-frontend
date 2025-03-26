//
//  VerifyPhoneViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit

class VerifyPhoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = verifyPhoneView
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var verifyPhoneView: VerifyPhoneView = {
        let view = VerifyPhoneView()
        view.phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.verifyButton.addTarget(self, action: #selector(didTapVerifyButton), for: .touchUpInside)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let allowedCharacters = CharacterSet.decimalDigits
        guard let input = textField.text else { return }
        let limitedText = String(input.prefix(11))
        verifyPhoneView.phoneTextField.text = limitedText
        
        // 숫자가 아닌 문자가 입력되면 주의 문구를 띄움
        let isOnlyNumbers = input.unicodeScalars.allSatisfy {
            allowedCharacters.contains($0)
        }

        if (isOnlyNumbers || input.isEmpty) {
            verifyPhoneView.phoneTextField.textColor = .grey700
            verifyPhoneView.phoneTextField.layer.borderColor = UIColor.grey400?.cgColor
            verifyPhoneView.alertLabel.isHidden = true
            
            if let count = textField.text?.count {
                if count >= 11 {
                    verifyPhoneView.verifyButton.setEnabled(true)
                } else {
                    verifyPhoneView.verifyButton.setEnabled(false)
                }
            }
        } else {
            verifyPhoneView.phoneTextField.textColor = .errorPrimary
            verifyPhoneView.phoneTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            verifyPhoneView.alertLabel.isHidden = false
        }
    }
    
    @objc func didTapVerifyButton() {
        verifyPhoneView.verifyCodeContainer.isHidden = false
        
        // MARK-: 테스트를 위한 임시구문
        let resetVC = ResetPasswordViewController()
        self.navigationController?.pushViewController(resetVC, animated: true)
    }
}
