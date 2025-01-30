//
//  YellowSplashViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SnapKit
import Then

class YellowSplashViewController: UIViewController {

    override func loadView() {
            // SplashView를 뷰로 설정
            let splashView = YellowSplashView()
            self.view = splashView
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            // 2초 후 메인 화면으로 전환
            //FIXME: - 개발 완료 후 delay 0.5 -> 1.5 로 변경하기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.transitionToMainScreen()
            }
        }

        private func transitionToMainScreen() {
            // 메인 화면으로 전환
            let view = OnBoardingViewController()
            let navigationController = UINavigationController(rootViewController: view)
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }

}
