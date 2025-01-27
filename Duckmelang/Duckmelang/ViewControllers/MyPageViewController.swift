//
//  MyPageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = myPageView
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var myPageView = MyPageView().then {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewDidTap))
        tapGesture.numberOfTapsRequired = 1 // 단일 탭, 횟수 설정
        $0.myPageTopView.backView.addGestureRecognizer(tapGesture)
        $0.idolChange.addTarget(self, action: #selector(idolChangeDidTap), for: .touchUpInside)
    }

    @objc
    private func backViewDidTap() {
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: false)
    }
    
    @objc
    private func idolChangeDidTap() {
        let idolChangeVC = UINavigationController(rootViewController: IdolChangeViewController())
        idolChangeVC.modalPresentationStyle = .fullScreen
        present(idolChangeVC, animated: false)
    }
}
