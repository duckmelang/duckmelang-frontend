//
//  VerifyPhoneViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit
import FirebaseAuth
import SwiftyToaster

class VerifyPhoneViewController: UIViewController {
    let networkService = LoginService()

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
        guard let phoneNum = textField.text else { return }

        // 1. 숫자만 필터링하고 11자리 제한
        let digitsOnly = phoneNum.filter { $0.isNumber }
        let limitedText = String(digitsOnly.prefix(11))

        // 2. 유효한 전화번호 조건: 11자리
        textField.text = limitedText
        let isValidPhoneNumber = limitedText.count == 11

        // 3. UI 업데이트
        verifyPhoneView.verifyButton.isEnabled = isValidPhoneNumber
    }
    
    @objc private func putCertificationNumber() {
        guard let text = verifyPhoneView.certificationNumberField.text else { return }
        
        let filteredText = text.filter { $0.isNumber }
        let limitedText = String(filteredText.prefix(6))
        
        verifyPhoneView.certificationNumberField.text = limitedText
        verifyPhoneView.verifyCodeButton.isEnabled = (limitedText.count == 6)
    }
    
    // 인증번호 요청 시 실행
    @objc func didTapVerifyButton() {
        guard let phoneNum = verifyPhoneView.phoneTextField.text else { return }
        guard phoneNum.count == 11 else { return }
        
        startCountdown()
        
        postSendCodeAPI(phoneNumber: phoneNum)
        
        self.verifyPhoneView.verifyCodeContainer.isHidden = false
        self.verifyPhoneView.phoneTextField.isEnabled = false
        self.verifyPhoneView.verifyButton.isEnabled = false
        self.verifyPhoneView.phoneVerifyContainer.alpha = 0.5
    }
    
    // 인증번호 요청 API
    private func postSendCodeAPI(phoneNumber: String) {
        let formattedPhoneNumber = formatPhoneNumberToE164(phoneNumber)
        print(formattedPhoneNumber)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
              if let error = error {
                    Toaster.shared.makeToast(error.localizedDescription)
                    print(error.localizedDescription)
                    return
              }
              if let verificationID = verificationID {
                  print("인증 요청 성공: \(verificationID)")
                  UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              } else {
                  Toaster.shared.makeToast("verificationID가 nil입니다.")
                  return
              }
              
          }
    }
    
    // MARK: - 인증번호 확인 버튼을 눌렀을 때 실행
    @objc func didTapVerifyCodeButton() {
        guard let code = verifyPhoneView.certificationNumberField.text, code.count == 6 else {
            Toaster.shared.makeToast("올바른 인증번호를 입력하세요.")
            return
        }
        
        postVerifyCodeAPI(code: code)
    }
    
    // 입력한 인증번호가 맞는지 확인하는 API
    private func postVerifyCodeAPI(code: String) {
        Task {
            startLoading()
            
            guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
                print("❌ verificationID가 없습니다")
                return
            }

            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: code
            )

            do {
                let result = try await Auth.auth().signIn(with: credential)
                print("로그인 성공: \(result.user.phoneNumber ?? "")")

                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "알림", message: "인증이 완료되었어요!", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        // 전화번호 인증 성공 시 아이디 찾기 함수 실행
                        self.getFindIdAPI()
                    }
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true)
                }
                
                stopLoading()
            } catch {
                print("로그인 실패: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
                
                stopLoading()
            }
        }
    }
    
    // 아이디 찾기
    private func getFindIdAPI() {
        guard let phoneNum = self.verifyPhoneView.phoneTextField.text else { return }
        
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getFindId(phoneNum: phoneNum)
                
                // MARK: 전화번호에 맞는 아이디가 있을 때
                let foundIDVC = FoundIDViewController()
                foundIDVC.phoneNum = phoneNum
                foundIDVC.foundId = result.loginId
                self.navigationController?.pushViewController(foundIDVC, animated: true)
                
                stopLoading()
            }
            catch {
                print(error.localizedDescription)
                Toaster.shared.makeToast(error.localizedDescription)
                
                // MARK: 전화번호에 맞는 아이디가 없을 때
                let notFoundIDVC = NotFoundIDViewController()
                self.navigationController?.pushViewController(notFoundIDVC, animated: true)
                
                stopLoading()
            }
        }
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
