//
//  PhoneSigninViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Moya

class PhoneSigninViewController: UIViewController, UITextFieldDelegate {
    private let provider = MoyaProvider<AllEndpoint>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = phoneSigninView
        
        setupNavigationBar()
    }
        
    private lazy var phoneSigninView: PhoneSigninView = {
        let view = PhoneSigninView()
        view.phoneTextField.delegate = self
        view.phoneTextField.addTarget(self, action: #selector(writePhoneNumber),for: .editingChanged)
        view.verifyButton.addTarget(self, action: #selector(didTapVerifyBtn),for: .touchUpInside)
        view.verifyButton.isEnabled = false // 초기 상태에서 비활성화
        view.verifyButton.alpha = 0.5 // 비활성화 시 투명도 50%
        
        view.certificationNumberField.addTarget(self, action: #selector(putCertificationNumber),for: .editingChanged)
        view.verifyCodeButton.addTarget(self, action: #selector(didTapVerifyCodeBtn),for: .touchUpInside)
        view.verifyCodeButton.isEnabled = false // 초기 상태에서 비활성화
        view.verifyCodeButton.alpha = 0.5 // 비활성화 시 투명도 50%
        return view
    }()
    
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
    
    @objc private func writePhoneNumber() {
        guard let text = phoneSigninView.phoneTextField.text else { return }

        // 숫자만 입력하도록 필터링
        let filteredText = text.filter { $0.isNumber }
            
        // 최대 11자리까지만 입력 가능하도록 설정
        let limitedText = String(filteredText.prefix(11))
        phoneSigninView.phoneTextField.text = limitedText

        // 11자리 입력되었을 때 색상 변경
        if limitedText.count == 11 {
            phoneSigninView.phoneTextField.textColor = UIColor.dmrBlue
            phoneSigninView.phoneTextField.layer.borderColor = UIColor.dmrBlue!.cgColor
            
            // 인증 버튼 활성화
            phoneSigninView.verifyButton.isEnabled = true
            phoneSigninView.verifyButton.alpha = 1.0
        } else {
            phoneSigninView.phoneTextField.textColor = UIColor.black
            phoneSigninView.phoneTextField.layer.borderColor = UIColor.grey400!.cgColor
            
            // 인증 버튼 비활성화
            phoneSigninView.verifyButton.isEnabled = false
            phoneSigninView.verifyButton.alpha = 0.5
        }
    }
    
    @objc private func didTapVerifyBtn() {
        guard let phoneNumber = phoneSigninView.phoneTextField.text, phoneNumber.count == 11 else { return }
        print(phoneNumber)
        print("인증요청 버튼 눌림")
        
        // 타임아웃 처리 DispatchWorkItem
        let timeoutWorkItem = DispatchWorkItem {
            self.showErrorPopup(
                message: "요청 시간이 초과되었습니다. 네트워크 상태를 확인하고 다시 시도해주세요."
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: timeoutWorkItem) // 5초 뒤 실행
        provider.request(.sendVerificationCode(phoneNumber: phoneNumber)) { result in
            timeoutWorkItem.cancel()
            switch result {
            case .success(let response):
                print("인증번호 전송 성공: \(response)")
                    
                // 인증번호 입력 필드 표시
                DispatchQueue.main.async {
                    self.phoneSigninView.verifyCodeContainer.alpha = 0
                    self.phoneSigninView.verifyCodeContainer.isHidden = false

                    self.phoneSigninView.phoneTextField.isUserInteractionEnabled = false
                    self.phoneSigninView.phoneTextField.textColor = .grey300
                    self.phoneSigninView.phoneTextField.layer.borderColor = UIColor.grey300!.cgColor

                    self.phoneSigninView.verifyButton.isEnabled = false
                    self.phoneSigninView.verifyButton
                        .setTitleColor(.grey100, for: .normal)
                    self.phoneSigninView.verifyButton.backgroundColor = .grey300

                    UIView.animate(withDuration: 0.3) {
                        self.phoneSigninView.verifyCodeContainer.alpha = 1
                    } completion: { _ in
                        self.phoneSigninView.certificationNumberField
                            .becomeFirstResponder()
                    }
                }
            case .failure(let error):
                print("인증번호 전송 실패: \(error)")
                DispatchQueue.main.async {
                    self.showErrorPopup(
                        message: "인증번호 전송에 실패.\n다시 시도해주세요"
                    )
                }
            }
            }
    }
    
    @objc private func putCertificationNumber() {
        guard let text = phoneSigninView.certificationNumberField.text else { return }

        // 숫자만 입력하도록 필터링
        let filteredText = text.filter { $0.isNumber }
        
        // 최대 6자리까지만 입력 가능하도록 설정
        let limitedText = String(filteredText.prefix(6))
        phoneSigninView.certificationNumberField.text = limitedText

        // 6자리 입력되었을 때 색상 변경
        if limitedText.count == 6 {
            phoneSigninView.certificationNumberField.textColor = UIColor.dmrBlue
            phoneSigninView.certificationNumberField.layer.borderColor = UIColor.dmrBlue!.cgColor
            // 인증 확인 버튼 활성화
            phoneSigninView.verifyCodeButton.isEnabled = true
            phoneSigninView.verifyCodeButton.alpha = 1.0
        } else {
            phoneSigninView.certificationNumberField.textColor = UIColor.black
            phoneSigninView.certificationNumberField.layer.borderColor = UIColor.grey400!.cgColor
            // 인증 확인 버튼 비활성화
            phoneSigninView.verifyCodeButton.isEnabled = false
            phoneSigninView.verifyCodeButton.alpha = 0.5
        }
    }
    
    @objc private func didTapVerifyCodeBtn() {
        guard let phoneNumber = phoneSigninView.phoneTextField.text, phoneNumber.count == 11,
              let code = phoneSigninView.certificationNumberField.text, code.count == 6 else {
            return
        }

        provider
            .request(
                .verifyCode(phoneNumber: phoneNumber, code: code)
            ) { result in
                switch result {
                case .success(let response):
                    print(phoneNumber)
                    print("인증 성공: \(response)")
                    DispatchQueue.main.async {
                        self.navigateToIDPWView()
                    }
                case .failure(let error):
                    print("인증 실패: \(error)")
                }
            }
    }
    
    private func navigateToIDPWView() {
        let view = SinginViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.grey600
        self.navigationController?.pushViewController(view, animated: true)

    }
    
    //FIXME: - 전화번호, 인증번호 설정 변경 필요 시 코드 수정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 숫자만 입력 가능하도록 제한
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        // 숫자가 아닌 문자는 입력 불가
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    private func showErrorPopup(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
