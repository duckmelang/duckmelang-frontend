//
//  LogoutPopupViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/20/25.
//

import UIKit

class LogoutPopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = logoutPopupView
    }
    
    private lazy var logoutPopupView = noImageCustomPopupView(title: "정말 로그아웃 하시겠습니까?", subTitle: "", leftBtnTitle: "아니요", rightBtnTitle: "네", height: 150).then {
        $0.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        $0.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
    }
    
    @objc private func leftBtnTap() {
        print("취소")
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func rightBtnTap() {
        print("로그아웃")
    }
}
