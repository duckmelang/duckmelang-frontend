//
//  FoundPasswordViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

class FoundPasswordViewController: UIViewController {
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
    
    @objc func didTapVerifyButton(_ textField: UITextField) {
        // 이건 아이디가 있을 때
        let newPwdVC = NewPasswordViewController()
        self.navigationController?.pushViewController(newPwdVC, animated: true)
        
        // 이건 아이디가 없을 떄
//        foundPasswordView.idTextField.setErrorState(true)
//        foundPasswordView.verifyButton.isEnabled = false
//        foundPasswordView.alertLabel.isHidden = false
    }
}
