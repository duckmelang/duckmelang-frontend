//
//  MyPageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class MyPageViewController: UIViewController {
   
    let networkService = MyPageService()
    
    private var profileData: myPageResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true

        getProfileInfo()
        
        self.view = myPageView
        myPageView.myPageTopView.isHidden = true

        startLoading()
        
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
        getProfileInfo()
    }
    
    //Notification을 받으면 프로필 정보를 다시 가져오는 함수
    @objc private func refreshProfile() {
        print("📢 프로필 업데이트 알림 수신 - 프로필 정보를 다시 가져옵니다.")
        getProfileInfo()
    }
    
    @objc private func profileSeeBtnDidTap() {
        let profileVC = ProfileViewController()
        guard self.profileData != nil else {
            print("프로필 정보를 불러올 수 없음.")
            return
        }
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc
    private func idolChangeDidTap() {
        let VC = IdolChangeViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc
    private func xKeywordDidTap() {
        let VC = XKeywordChangeViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc
    private func postFilterChangeDidTap() {
        let VC = PostFilterViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc
    private func loginInfoDidTap() {
        let VC = LoginInfoViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc
    private func pushDidTap() {
        let VC = PushNotificationViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc
    private func outDidTap() {
        let VC = AccountClosing1ViewController()
        self.navigationController?.pushViewController(VC, animated: true)
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
                self.startLoading()
                
                let result = try await networkService.getMyPage()
                self.profileData = result
                
                self.updateMyPageTopView(with: result)
                
                myPageView.myPageTopView.isHidden = false
                self.stopLoading()
            } catch {
                self.stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateMyPageTopView(with data: myPageResponse) {
        self.myPageView.myPageTopView.nickname.text = data.nickname
        self.myPageView.myPageTopView.genderAndAge.text = "\(data.localizedGender)  |  \(data.localizedAge)"
        
        if let url = URL(string: data.latestPublicMemberProfileImage) {
            myPageView.myPageTopView.profileImage.kf.setImage(with: url, placeholder: UIImage(resource: .profile))
        }
    }
}

