//
//  SignUpCompleteViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 5/10/25.
//

import UIKit

class SignUpCompleteViewController: UIViewController {
    override func loadView() {
        self.view = BlueSplashView(
            title: "환영해요!",
            subTitle: "나와 잘 맞는 메랑이를 찾아봐요!"
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.transitionToOnBoarding()
        }
    }
    
    private func transitionToOnBoarding() {
        // 온보딩 화면으로 전환
        let view = OnBoardingViewController()
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
