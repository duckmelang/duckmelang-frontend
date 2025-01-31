//
//  SignUpViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = signupView
        setupNavigationBar()
    }
    
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
    
    // MARK: - Properties
        
    private lazy var signupView: SignUpView = {
            let view = SignUpView()
            view.signUpButton.addTarget(self, action: #selector(didTapSigninButton), for: .touchUpInside)
            return view
    }()

    
    
    @objc private func didTapSigninButton() {
        navigateToMakeProfileView()
        print("goto MakeProfile")
    }
    
    // MARK: - Navigation
    
    private func navigateToMakeProfileView() {
        let view = MakeProfilesViewController()
        self.navigationController?.pushViewController(view, animated: true)
    }

}
