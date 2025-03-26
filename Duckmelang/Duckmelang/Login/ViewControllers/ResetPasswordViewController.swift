//
//  ResetPasswordViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = resetPasswordView
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    private lazy var resetPasswordView: ResetPasswordView = {
        let view = ResetPasswordView()
        view.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        resetPasswordView.verifyButton.setEnabled(!text.isEmpty)
    }
    
    @objc func didTapVerifyButton(_ textField: UITextField) {
        // MARK-: 테스트를 위한 임시 구문
        let completeVC = CompleteResetPasswordViewController()
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
}
