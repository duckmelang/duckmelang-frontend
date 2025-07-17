//
//  ProfileCancelPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 6/29/25.
//

import UIKit

class ProfileCancelPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = noImageCustomPopupView(
            title: "시작 화면으로 돌아가시겠어요?",
            subTitle: "지금까지 입력하신 정보는 저장되지 않아요.",
            leftBtnTitle: "취소",
            rightBtnTitle: "돌아가기"
        )
        
        view.panel.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        view.leftBtn.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        view.rightBtn.addTarget(self, action: #selector(goOnboarding), for: .touchUpInside)
        self.view = view
    }
    
    @objc private func dismissPopup() {
        dismiss(animated: false)
    }
    
    @objc func goOnboarding() {
        let onboardingVC = OnBoardingViewController()
        let navController = UINavigationController(rootViewController: onboardingVC)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navController
            })
        }
    }
}
