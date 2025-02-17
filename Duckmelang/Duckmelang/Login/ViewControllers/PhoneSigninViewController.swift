//
//  PhoneSigninViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Moya

class PhoneSigninViewController: UIViewController, UITextFieldDelegate, MoyaErrorHandlerDelegate {
    func showErrorAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirmAction)
            alert.view.tintColor = UIColor.red
            self.present(alert, animated: true)
        }
    }
    
    
    // MARK: - Properties
    lazy var provider: MoyaProvider<LoginAPI> = {
            return MoyaProvider<LoginAPI>(plugins: [MoyaLoggerPlugin(delegate: self)])
        }()

    private var countdownTimer: Timer?
    private var remainingSeconds = 180

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = phoneSigninView
        
        setupNavigationBar()
    }
        
    private lazy var phoneSigninView: PhoneSigninView = {
        let view = PhoneSigninView()
        view.phoneTextField.delegate = self
        view.phoneTextField.addTarget(self, action: #selector(writePhoneNumber), for: .editingChanged)
        view.verifyButton.addTarget(self, action: #selector(didTapSendBtn), for: .touchUpInside)
        view.verifyButton.isEnabled = false
        view.verifyButton.alpha = 0.5
        
        view.certificationNumberField.addTarget(self, action: #selector(putCertificationNumber), for: .editingChanged)
        view.verifyCodeButton.addTarget(self, action: #selector(didTapVerifyCodeBtn), for: .touchUpInside)
        view.verifyCodeButton.isEnabled = false
        view.verifyCodeButton.alpha = 0.5
        
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
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

    // MARK: - 인증번호 요청
    @objc private func didTapSendBtn() {
        guard let phoneNumber = phoneSigninView.phoneTextField.text, phoneNumber.count == 11 else { return }
        print("📡 인증 요청 버튼 눌림: \(phoneNumber)")

        resetCountdown()

        // 5초 후 타임아웃 팝업을 띄우기 위한 DispatchWorkItem 설정
        let timeoutWorkItem = DispatchWorkItem {
            DispatchQueue.main.async {
                self.showErrorAlert(title: "요청시간 초과", message: "요청 시간이 초과되었습니다. 다시 시도해주세요.")
            }
        }

        // 5초 후 실행 (만약 응답이 오면 취소됨)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: timeoutWorkItem)

        // 🔥 인증번호 요청 API 호출
        provider.request(.postSendVerificationCode(phoneNum: phoneNumber)) { result in
            timeoutWorkItem.cancel()

            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(VerifyCodeResponse.self)
                    
                    if decodedResponse.isSuccess {
                        if let resultMessage = decodedResponse.result {
                            self.showPopup(message: resultMessage)
                            
                            // ✅ 인증 성공 시 verifyCodeContainer 활성화
                            DispatchQueue.main.async {
                                self.phoneSigninView.verifyCodeContainer.isHidden = false
                                self.startCountdown()
                            }
                        }
                    } else {
                        self.showErrorAlert(title: "실패", message: decodedResponse.message)
                    }
                } catch {
                    self.showErrorAlert(title: "오류", message: "응답을 해석하는 데 실패했습니다.")
                }

            case .failure(let error):
                self.showErrorAlert(title: "실패", message: error.localizedDescription)
            }
        }
    }

    // MARK: - 성공 팝업 표시
    func showPopup(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            self.present(alert, animated: true)

            // 일정 시간 후 자동으로 닫히도록 설정 (예: 0.5초 후)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - 인증번호 입력 후 확인
    @objc private func didTapVerifyCodeBtn() {
        guard let phoneNumber = phoneSigninView.phoneTextField.text, phoneNumber.count == 11,
              let code = phoneSigninView.certificationNumberField.text, code.count == 6 else {
            showErrorAlert(title: "오류", message: "올바른 인증번호를 입력하세요.")
            return
        }

        provider.request(.postVerifyCode(phoneNumber: phoneNumber, code: code)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(VerifyCodeResponse.self)
                    
                    if decodedResponse.isSuccess {
                        if let resultMessage = decodedResponse.result {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "알림", message: resultMessage, preferredStyle: .alert)
                                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                                    self.navigateToIDPWView()
                                }
                                alert.addAction(confirmAction)
                                self.present(alert, animated: true)
                            }
                        }
                    } else {
                        self.showErrorAlert(title: "오류", message: decodedResponse.message)
                    }
                } catch {
                    self.showErrorAlert(title: "오류", message: "응답을 해석하는 데 실패했습니다.")
                }

            case .failure(let error):
                self.showErrorAlert(title: "오류", message: error.localizedDescription)
            }
        }
    }

    // MARK: - 인증번호 타이머 관리
    private func startCountdown() {
        print("⏳ 인증 타이머 시작!")
        remainingSeconds = 180
        phoneSigninView.certificationNumberField.placeholder = "03:00"
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateCountdownUI()
        }
    }

    private func updateCountdownUI() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            phoneSigninView.certificationNumberField.placeholder = String(format: "%02d:%02d", minutes, seconds)
        } else {
            resetCountdown()
        }
    }

    private func resetCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        phoneSigninView.certificationNumberField.placeholder = "(인증시간 초과)"

        DispatchQueue.main.async {
            self.phoneSigninView.verifyButton.isEnabled = true
            self.phoneSigninView.verifyButton.alpha = 1.0
            self.phoneSigninView.verifyButton.setTitleColor(.white, for: .normal)
            self.phoneSigninView.verifyButton.backgroundColor = UIColor.dmrBlue

            self.phoneSigninView.phoneTextField.isUserInteractionEnabled = true
            self.phoneSigninView.phoneTextField.textColor = .black
            self.phoneSigninView.phoneTextField.layer.borderColor = UIColor.grey400!.cgColor
        }
    }

    func navigateToIDPWView() {
        print("⏭️ Go SignUPViewController")
        let view = SignUpViewController()
        self.navigationController?.pushViewController(view, animated: true)
    }

    // MARK: - 전화번호 입력 필터링
    @objc private func writePhoneNumber() {
        guard let text = phoneSigninView.phoneTextField.text else { return }
        let filteredText = text.filter { $0.isNumber }
        let limitedText = String(filteredText.prefix(11))
        phoneSigninView.phoneTextField.text = limitedText

        if limitedText.count == 11 {
            phoneSigninView.phoneTextField.textColor = UIColor.dmrBlue
            phoneSigninView.phoneTextField.layer.borderColor = UIColor.dmrBlue!.cgColor
            phoneSigninView.verifyButton.isEnabled = true
            phoneSigninView.verifyButton.alpha = 1.0
        } else {
            phoneSigninView.phoneTextField.textColor = UIColor.black
            phoneSigninView.phoneTextField.layer.borderColor = UIColor.grey400!.cgColor
            phoneSigninView.verifyButton.isEnabled = false
            phoneSigninView.verifyButton.alpha = 0.5
        }
    }

    @objc private func putCertificationNumber() {
        guard let text = phoneSigninView.certificationNumberField.text else { return }
        let filteredText = text.filter { $0.isNumber }
        let limitedText = String(filteredText.prefix(6))
        phoneSigninView.certificationNumberField.text = limitedText

        if limitedText.count == 6 {
            phoneSigninView.certificationNumberField.textColor = UIColor.dmrBlue
            phoneSigninView.certificationNumberField.layer.borderColor = UIColor.dmrBlue!.cgColor
            phoneSigninView.verifyCodeButton.isEnabled = true
            phoneSigninView.verifyCodeButton.alpha = 1.0
        } else {
            phoneSigninView.certificationNumberField.textColor = UIColor.black
            phoneSigninView.certificationNumberField.layer.borderColor = UIColor.grey400!.cgColor
            phoneSigninView.verifyCodeButton.isEnabled = false
            phoneSigninView.verifyCodeButton.alpha = 0.5
        }
    }
}
