//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit

class SinginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view = loginView
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
        
    private lazy var loginView: SinginView = {
        let view = SinginView()
        return view
    }()

    
    
//    @objc private func didTapLoginButton() {
//        navigateToHomeView()
//        print("gotoMain")
//    }
    
    // MARK: - Navigation
    
//    private func navigateToHomeView() {
//        let mainVC = BaseViewController()
//        mainVC.modalPresentationStyle = .fullScreen
//        present(mainVC, animated: true)
//    }

}
