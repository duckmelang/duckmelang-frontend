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

    override func loadView() {
        // SplashView를 뷰로 설정
        let splashView = BlueSplashView()
        self.view = splashView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 1.5초 후 현재 화면 닫기
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
