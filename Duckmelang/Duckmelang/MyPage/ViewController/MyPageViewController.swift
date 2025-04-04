//
//  MyPageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let networkService = MyPageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = myPageView
        
        navigationController?.isNavigationBarHidden = true
        
        getProfileInfo()
        
        //NotificationCenter 등록
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile(_:)), name: NSNotification.Name("ProfileUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var myPageView = MyPageView().then {
        $0.myPageTopView.profileSeeBtn.addTarget(self, action: #selector(profileSeeBtnDidTap), for: .touchUpInside)
        $0.idolChange.addTarget(self, action: #selector(idolChangeDidTap), for: .touchUpInside)
        $0.xKeywordChange.addTarget(self, action: #selector(xKeywordDidTap), for: .touchUpInside)
        $0.postFilterChange.addTarget(self, action: #selector(postFilterChangeDidTap), for: .touchUpInside)
        $0.login.addTarget(self, action: #selector(loginInfoDidTap), for: .touchUpInside)
        $0.push.addTarget(self, action: #selector(pushDidTap), for: .touchUpInside)
        $0.out.addTarget(self, action: #selector(outDidTap), for: .touchUpInside)
        $0.logout.addTarget(self, action: #selector(logoutDidTap), for: .touchUpInside)
    }
    
    // MARK: - Notification Handling
    @objc private func updateProfile(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let nickname = userInfo["nickname"] as? String,
              let introduction = userInfo["introduction"] as? String,
              let imageURLString = userInfo["imageURL"] as? String,
              let imageURL = URL(string: imageURLString) else { return }
        
        print("📢 프로필 업데이트 알림 수신 - UI 갱신")
        
        DispatchQueue.main.async {
            self.myPageView.myPageTopView.nickname.text = nickname
            self.myPageView.myPageTopView.profileImage.kf.setImage(with: imageURL)
            self.myPageView.myPageTopView.profileImage.contentMode = .scaleAspectFill
        }
    }
    
    //Notification을 받으면 프로필 정보를 다시 가져오는 함수
    @objc private func refreshProfile() {
        print("📢 프로필 업데이트 알림 수신 - 프로필 정보를 다시 가져옵니다.")
        getProfileInfo()
    }
    
    @objc private func profileSeeBtnDidTap() {
        let profileVC = ProfileViewController()
        profileVC.profileData = myPageView.myPageTopView.profileData // 데이터 전달
        
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc
    private func idolChangeDidTap() {
        let idolChangeVC = UINavigationController(rootViewController: IdolChangeViewController())
        idolChangeVC.modalPresentationStyle = .fullScreen
        present(idolChangeVC, animated: false)
    }
    
    @objc
    private func xKeywordDidTap() {
        let xKeywordChangeVC = UINavigationController(rootViewController: XKeywordChangeViewController())
        xKeywordChangeVC.modalPresentationStyle = .fullScreen
        present(xKeywordChangeVC, animated: false)
    }
    
    @objc
    private func postFilterChangeDidTap() {
        let postFilterVC = UINavigationController(rootViewController: PostFilterViewController())
        postFilterVC.modalPresentationStyle = .fullScreen
        present(postFilterVC, animated: false)
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
    
    @objc
    private func logoutDidTap() {
        let logoutPopupVC = LogoutPopupViewController()
        logoutPopupVC.modalPresentationStyle = .overFullScreen
        present(logoutPopupVC, animated: false)
    }
    
    //마이페이지에서 내 프로필 가져오기
    private func getProfileInfo() {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getProfile()
                
                DispatchQueue.main.async {
                    self.myPageView.myPageTopView.profileData = result
                    self.myPageView.myPageTopView.profileImage.contentMode = .scaleAspectFill
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
}


