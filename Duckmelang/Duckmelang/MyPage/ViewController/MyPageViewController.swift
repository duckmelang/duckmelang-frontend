//
//  MyPageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import Moya

class MyPageViewController: UIViewController {
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = myPageView
        
        navigationController?.isNavigationBarHidden = true
        
        getProfileInfo()
    }
    
    private lazy var myPageView = MyPageView().then {
        $0.myPageTopView.profileSeeBtn.addTarget(self, action: #selector(profileSeeBtnDidTap), for: .touchUpInside)
        $0.idolChange.addTarget(self, action: #selector(idolChangeDidTap), for: .touchUpInside)
        $0.postRecommendChange.addTarget(self, action: #selector(postRecommendDidTap), for: .touchUpInside)
        $0.login.addTarget(self, action: #selector(loginInfoDidTap), for: .touchUpInside)
        $0.push.addTarget(self, action: #selector(pushDidTap), for: .touchUpInside)
        $0.out.addTarget(self, action: #selector(outDidTap), for: .touchUpInside)
        $0.goBtn.addTarget(self, action: #selector(goBtnDidTap), for: .touchUpInside)
    }
    
    @objc private func goBtnDidTap() {
        let postDetailVC = UINavigationController(rootViewController: PostDetailViewController())
        postDetailVC.modalPresentationStyle = .fullScreen
        present(postDetailVC, animated: true)
    }
    
    
    @objc private func profileSeeBtnDidTap() {
        let profileVC = ProfileViewController()
        profileVC.profileData = myPageView.myPageTopView.profileData // 데이터 전달
        
        let navigationVC = UINavigationController(rootViewController: profileVC)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
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
    
    //내 프로필 가져오기
    private func getProfileInfo() {
        provider.request(.getProfile(memberId: 1)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<ProfileData>.self)
                guard let profile = response?.result else { return }
                
                //MyPageTopView에 데이터 반영
                DispatchQueue.main.async {
                    self.myPageView.myPageTopView.profileData = profile
                }
                
            case .failure(let error):
                print(" 프로필 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}


