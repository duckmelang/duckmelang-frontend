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
        view.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: .editingChanged)
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
    
    @objc func phoneTextFieldDidChange(_ textField: UITextField) {
        let allowedCharacters = CharacterSet.decimalDigits
        guard let input = textField.text else { return }

        // 1. 숫자만 필터링하고 11자리 제한
        let digitsOnly = input.filter { $0.isNumber }
        let limitedText = String(digitsOnly.prefix(11))

        // 2. 전화번호 형식으로 변환
        let formatted = formatPhoneNumber(limitedText)
        textField.text = formatted

        // 3. 숫자인지 여부는 limitedText 기준으로 검사해야 함
        let isOnlyNumbers = limitedText.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }

        // 4. 유효한 전화번호 조건: 숫자만 + 11자리
        let isValidPhoneNumber = isOnlyNumbers && limitedText.count == 11

        if isOnlyNumbers || limitedText.isEmpty {
            verifyPhoneView.alertLabel.isHidden = true
            verifyPhoneView.phoneTextField.textColor = .grey700

            if isValidPhoneNumber {
                verifyPhoneView.phoneTextField.layer.borderColor = UIColor.dmrBlue?.cgColor
                verifyPhoneView.verifyButton.setEnabled(true)
            } else {
                verifyPhoneView.phoneTextField.layer.borderColor = UIColor.grey400?.cgColor
                verifyPhoneView.verifyButton.setEnabled(false)
            }
        } else {
            verifyPhoneView.phoneTextField.textColor = .errorPrimary
            verifyPhoneView.phoneTextField.layer.borderColor = UIColor.errorPrimary?.cgColor
            verifyPhoneView.alertLabel.isHidden = false
            verifyPhoneView.verifyButton.setEnabled(false)
        }
    }


    
    @objc func didTapVerifyButton() {
        verifyPhoneView.verifyCodeContainer.isHidden = false
        
        // MARK-: 테스트를 위한 임시구문
        let resetVC = ResetPasswordViewController()
        self.navigationController?.pushViewController(resetVC, animated: true)
    }
}
