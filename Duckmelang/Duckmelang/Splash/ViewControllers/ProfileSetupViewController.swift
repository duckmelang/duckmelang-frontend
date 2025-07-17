//
//  ProfileSplashViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 3/30/25.
//

import UIKit

class ProfileSplashViewController: UIViewController {
    override func loadView() {
        self.view = BlueSplashView(
            title: "아직 프로필이 완성되지 않았어요",
            subTitle: "메랑이가 되기 위한 준비를 해볼까요?"
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.transitionToNextScreen()
        }
    }
    
    private func transitionToNextScreen() {
        let view = SetupNickBirthGenViewController()
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
