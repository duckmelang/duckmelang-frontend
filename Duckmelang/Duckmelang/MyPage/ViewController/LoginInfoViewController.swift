//
//  LoginInfoViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class LoginInfoViewController: UIViewController {
    
    //kakao, google 연동 되어있는지 여부
    var kakaoLogin = false
    var googleLogin = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = loginInfoView
        
        navigationController?.isNavigationBarHidden = true
        
        loginKaKaoIsTrue()
        loginGoogleIsTrue()
    }

    private lazy var loginInfoView = LoginInfoView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    private func loginKaKaoIsTrue() {
        if kakaoLogin == true {
            loginInfoView.kakaoCheckIcon.isHidden = false
            loginInfoView.kakaoText.textColor = .grey800
        } else {
            loginInfoView.kakaoCheckIcon.isHidden = true
            loginInfoView.kakaoText.textColor = .grey600
        }
    }
    
    private func loginGoogleIsTrue() {
        if googleLogin == true {
            loginInfoView.googleCheckIcon.isHidden = false
            loginInfoView.googleText.textColor = .grey800
        } else {
            loginInfoView.googleCheckIcon.isHidden = true
            loginInfoView.googleText.textColor = .grey600
        }
    }
}
