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
            self.transitionToNextScreen()
        }
    }
    
    private func transitionToNextScreen() {
        let view = BaseViewController()
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hidesBottomBarWhenPushed = true
        self.present(navigationController, animated: true, completion: nil)
    }
}
