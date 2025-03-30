//
//  BlueSplashViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import SnapKit
import Then

class BlueSplashViewController: UIViewController {
    override func viewDidLoad() {
        self.view = BlueSplashView(title: "인증이 완료되었어요!", subTitle: "메랑이가 되기 위한 준비를 해볼까요?")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.transitionToNextScreen()
//        }
    }

//    private func transitionToNextScreen() {
//        // 프로필 작성 화면으로 전환
//        let view = makeProfileViewController()
//        view.modalTransitionStyle = .crossDissolve
//        view.modalPresentationStyle = .fullScreen
//        self.present(view, animated: true)
//    }
}
