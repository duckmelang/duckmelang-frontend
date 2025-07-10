//
//  LogoutPopupViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/20/25.
//

import UIKit

class LogoutPopupViewController: UIViewController {
    let networkService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = logoutPopupView
    }
    
    private lazy var logoutPopupView = noImageCustomPopupView(title: "정말 로그아웃 하시겠습니까?", subTitle: "", leftBtnTitle: "아니요", rightBtnTitle: "네").then {
        $0.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        $0.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
    }
    
    @objc private func leftBtnTap() {
        print("취소")
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func rightBtnTap() {
        print("로그아웃")
        logout()
    }
    
    private func logout() {
        Task {
            startLoading()
            defer { stopLoading() } // 마지막에 실행됨
            
            KeychainManager.shared.delete(key: "accessToken")
            KeychainManager.shared.delete(key: "refreshToken")
            
            DispatchQueue.main.async {
                self.goToLoginScreen()
            }
        }
    }
    
    // ✅ 로그인 화면으로 이동
    private func goToLoginScreen() {
        // 스택 구성: OnBoarding → Login 순서로
        let onboardingVC = OnBoardingViewController()
        let loginVC = LoginViewController()
        let nav = UINavigationController()
        nav.setViewControllers([onboardingVC, loginVC], animated: false)
        
        // rootViewController 교체
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = scene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = nav
            delegate.window?.makeKeyAndVisible()
        }
    }
}
