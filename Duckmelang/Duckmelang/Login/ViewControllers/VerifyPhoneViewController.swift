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
    
    private var countdownTimer: Timer?
    private var remainingSeconds = 180
    
    private lazy var verifyPhoneView: VerifyPhoneView = {
        let view = VerifyPhoneView()
        view.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: .editingChanged)
        view.certificationNumberField.addTarget(self, action: #selector(putCertificationNumber), for: .editingChanged)
        view.verifyButton.addTarget(self, action: #selector(didTapVerifyButton), for: .touchUpInside)
        view.verifyCodeButton.addTarget(self, action: #selector(didTapVerifyCodeButton), for: .touchUpInside)
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationItem.title = "아이디 찾기"
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
        guard let input = textField.text else { return }

        // 1. 숫자만 필터링하고 11자리 제한
        let digitsOnly = input.filter { $0.isNumber }
        let limitedText = String(digitsOnly.prefix(11))

        // 2. 전화번호 형식으로 변환
        let formatted = formatPhoneNumber(limitedText)
        textField.text = formatted

        // 3. 유효한 전화번호 조건: 11자리
        let isValidPhoneNumber = limitedText.count == 11

        // 4. UI 업데이트
        verifyPhoneView.verifyButton.isEnabled = isValidPhoneNumber
    }
    
    @objc private func putCertificationNumber() {
        guard let text = verifyPhoneView.certificationNumberField.text else { return }
        
        let filteredText = text.filter { $0.isNumber }
        let limitedText = String(filteredText.prefix(6))
        
        verifyPhoneView.certificationNumberField.text = limitedText
        verifyPhoneView.verifyCodeButton.isEnabled = (limitedText.count == 6)
    }
    
    @objc func didTapVerifyButton() {
        startCountdown()
        
        // MARK: TEST - 인증번호 성공 시
        self.verifyPhoneView.verifyCodeContainer.isHidden = false
        
        self.verifyPhoneView.phoneTextField.isEnabled = false
        self.verifyPhoneView.verifyButton.isEnabled = false
        self.verifyPhoneView.phoneVerifyContainer.alpha = 0.5
    }
    
    @objc func didTapVerifyCodeButton() {
        // MARK: - 테스트를 위한 임시구문, 이건 전화번호에 맞는 아이디가 있을 때
//        let foundIDVC = FoundIDViewController()
//        foundIDVC.phoneNum = self.verifyPhoneView.phoneTextField.text ?? ""
//        self.navigationController?.pushViewController(foundIDVC, animated: true)
        
        // MARK: 여긴 맞는 아이디가 없을 때
        let notFoundIDVC = NotFoundIDViewController()
        self.navigationController?.pushViewController(notFoundIDVC, animated: true)
    }
    
    // MARK: - 인증번호 타이머 관리
    private func startCountdown() {
        print("인증 타이머 시작")
        remainingSeconds = 180
        updateCountdownUI()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            self.updateCountdownUI()
        }
    }

    private func updateCountdownUI() {
        if remainingSeconds >= 0 {
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            verifyPhoneView.certificationNumberField.placeholder = String(format: "%02d:%02d", minutes, seconds)
        }

        if remainingSeconds == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.resetCountdown()
            }
        }
    }

    private func resetCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingSeconds = 0

        // 텍스트 필드 초기화 + 제한 표시
        verifyPhoneView.certificationNumberField.text = ""
        verifyPhoneView.certificationNumberField.placeholder = "제한시간이 초과되었어요"

        // 인증 버튼 비활성화
        verifyPhoneView.verifyCodeButton.isEnabled = false
    }
}
