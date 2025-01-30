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
        $0.myPageTopView.profileSeeBtn.addTarget(self, action: #selector(profileSeeBtnDidTap), for: .touchUpInside)
        $0.idolChange.addTarget(self, action: #selector(idolChangeDidTap), for: .touchUpInside)
        $0.postRecommendChange.addTarget(self, action: #selector(postRecommendDidTap), for: .touchUpInside)
        $0.login.addTarget(self, action: #selector(loginInfoDidTap), for: .touchUpInside)
        $0.push.addTarget(self, action: #selector(pushDidTap), for: .touchUpInside)
        $0.out.addTarget(self, action: #selector(outDidTap), for: .touchUpInside)
    }
    
    @objc
    private func profileSeeBtnDidTap() {
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
    
    @objc
    private func postRecommendDidTap() {
        let PostRecommendedFilterVC = UINavigationController(rootViewController: PostRecommendedFilterViewController())
        PostRecommendedFilterVC.modalPresentationStyle = .fullScreen
        present(PostRecommendedFilterVC, animated: false)
    }
    
    @objc
    private func loginInfoDidTap() {
        let loginInfoVC = UINavigationController(rootViewController: LoginInfoViewController())
        loginInfoVC.modalPresentationStyle = .fullScreen
        present(loginInfoVC, animated: false)
    }
    
    @objc
    private func pushDidTap() {
        let pushVC = UINavigationController(rootViewController: PushNotificationViewController())
        pushVC.modalPresentationStyle = .fullScreen
        present(pushVC, animated: false)
    }
    
    @objc
    private func outDidTap() {
        let outVC = UINavigationController(rootViewController: AccountClosing1ViewController())
        outVC.modalPresentationStyle = .fullScreen
        present(outVC, animated: false)
    }
}


