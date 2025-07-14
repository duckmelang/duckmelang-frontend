//
//  PhoneSigninViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/25/25.
//

import UIKit
import FirebaseAuth
import SwiftyToaster

class PhoneSigninViewController: UIViewController, UITextFieldDelegate {
    let networkService = LoginService()
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirmAction)
            alert.view.tintColor = UIColor.red
            self.present(alert, animated: true)
        }
    }

    private var countdownTimer: Timer?
    private var remainingSeconds = 180

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = phoneSigninView
        
        setupAction()
        setupNavigationBar()
    }
        
    private lazy var phoneSigninView: PhoneSigninView = {
        let view = PhoneSigninView()
        return view
    }()
    
    private func setupAction() {
        phoneSigninView.phoneTextField.delegate = self
        phoneSigninView.phoneTextField.addTarget(self, action: #selector(writePhoneNumber), for: .editingChanged)
        phoneSigninView.verifyButton.addTarget(self, action: #selector(didTapSendBtn), for: .touchUpInside)
        phoneSigninView.certificationNumberField.addTarget(self, action: #selector(putCertificationNumber), for: .editingChanged)
        phoneSigninView.verifyCodeButton.addTarget(self, action: #selector(didTapVerifyCodeBtn), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
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
        guard let rawText = phoneSigninView.phoneTextField.text else { return }
        
        let digitsOnly = rawText.filter { $0.isNumber }
        guard digitsOnly.count == 11 else { return }
        
        getCheckPhoneNumAPI(phoneNum: rawText)
    }
    
    // 전화번호 중복 확인하기
    private func getCheckPhoneNumAPI(phoneNum: String) {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getCheckPhoneNum(phoneNum: phoneNum)
                
                if (result.isDuplicate) {
                    // 전화번호가 중복되는 경우
                    self.phoneSigninView.phoneTextField.setErrorState(true)
                    self.phoneSigninView.alertLabel.isHidden = false
                } else {
                    // 전화번호가 중복되지않는 경우 -> 인증번호 보냄
                    startCountdown()
                    
                    postSendCodeAPI(phoneNumber: phoneNum)

                    self.phoneSigninView.verifyCodeContainer.isHidden = false
                    self.phoneSigninView.phoneTextField.isEnabled = false
                    self.phoneSigninView.verifyButton.isEnabled = false
                    self.phoneSigninView.phoneVerifyContainer.alpha = 0.5
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast(error.localizedDescription)
            }
        }
    }
    
    private func postSendCodeAPI(phoneNumber: String) {
        let formattedPhoneNumber = formatPhoneNumberToE164(phoneNumber)
        
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
        guard let code = phoneSigninView.certificationNumberField.text, code.count == 6 else {
            showAlert(title: "오류", message: "올바른 인증번호를 입력하세요.")
            return
        }
        
        postVerifyCodeAPI(code: code)
    }
    
    private func postVerifyCodeAPI(code: String) {
        Task {
            startLoading()
            
            guard let phoneNum = phoneSigninView.phoneTextField.text else { return }
            
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
                    self.postPhoneNum(phoneNum: phoneNum)
                    
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigateToIDPWView()
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
    
    // 전화번호 등록
    private func postPhoneNum(phoneNum: String) {
        Task {
            do {
                startLoading()
                
                _ = try await networkService.postPhoneNum(phoneNum: phoneNum)
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("전화번호 등록에 실패했습니다. 잠시 후 다시 시도해주세요.")
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
            phoneSigninView.certificationNumberField.placeholder = String(format: "%02d:%02d", minutes, seconds)
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
        phoneSigninView.certificationNumberField.text = ""
        phoneSigninView.certificationNumberField.placeholder = "제한시간이 초과되었어요"

        // 인증 버튼 비활성화
        phoneSigninView.verifyCodeButton.isEnabled = false
    }

    func navigateToIDPWView() {
        let view = SignUpViewController()
        self.navigationController?.pushViewController(view, animated: true)
    }

    // MARK: - 전화번호 입력 필터링
    @objc private func writePhoneNumber() {
        guard let text = phoneSigninView.phoneTextField.text else { return }
        
        let digitsOnly = text.filter { $0.isNumber }
        let limitedText = String(digitsOnly.prefix(11))

        phoneSigninView.phoneTextField.text = limitedText

        // 에러 상태일 경우 초기화
        if phoneSigninView.phoneTextField.isInErrorState {
            phoneSigninView.phoneTextField.setErrorState(false)
            phoneSigninView.alertLabel.isHidden = true
        }

        phoneSigninView.verifyButton.isEnabled = (limitedText.count == 11)
    }

    // MARK: - 코드 입력 필터링
    @objc private func putCertificationNumber() {
        guard let text = phoneSigninView.certificationNumberField.text else { return }
        
        let filteredText = text.filter { $0.isNumber }
        let limitedText = String(filteredText.prefix(6))
        
        phoneSigninView.certificationNumberField.text = limitedText
        phoneSigninView.verifyCodeButton.isEnabled = (limitedText.count == 6)
    }
}
