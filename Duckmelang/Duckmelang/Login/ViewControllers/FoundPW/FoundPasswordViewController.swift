//
//  FoundPasswordViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit
import SwiftyToaster

class FoundPasswordViewController: UIViewController {
    let networkService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = foundPasswordView
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var foundPasswordView: FoundPasswordView = {
        let view = FoundPasswordView()
        view.idTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        let text = textField.text ?? ""
        
        // 에러 상태일 경우에만 처리 (내부에서 상태 자동 전환됨)
        if foundPasswordView.idTextField.isInErrorState {
            foundPasswordView.idTextField.setErrorState(false)
            foundPasswordView.alertLabel.isHidden = true
        }

        // 버튼 활성화 여부 갱신
        foundPasswordView.verifyButton.isEnabled = !text.isEmpty
    }
    
    // 아이디 입력 후 확인 버튼 누를 때
    @objc func didTapVerifyButton() {
        guard let loginId = foundPasswordView.idTextField.text else { return }
        getCheckNicknameAPI(loginId: loginId)
    }
    
    // 아이디가 있는 지 확인하기
    private func getCheckNicknameAPI(loginId: String) {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getCheckNickname(loginId: loginId)
                if (result.isDuplicate) {
                    // 아이디가 있는 경우
                    let newPwdVC = NewPasswordViewController()
                    newPwdVC.id = loginId
                    self.navigationController?.pushViewController(newPwdVC, animated: true)
                } else {
                    // 아이디가 없는 경우
                    foundPasswordView.idTextField.setErrorState(true)
                    foundPasswordView.verifyButton.isEnabled = false
                    foundPasswordView.alertLabel.isHidden = false
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
}
