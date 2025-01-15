//
//  LoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "로그인"
        
        // 네비게이션 바 타이틀 폰트 설정
        if let navigationController = self.navigationController {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)
            ]
        }
    }
    private func setupView(){
        let loginView = LoginView()
        self.view = loginView
    }

}
