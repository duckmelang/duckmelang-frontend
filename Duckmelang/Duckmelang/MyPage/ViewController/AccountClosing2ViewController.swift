//
//  AccountClosing2ViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class AccountClosing2ViewController: UIViewController {
    
    let networkService = MyPageService()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = accountClosing2View
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var accountClosing2View = AccountClosing2View().then {
        $0.outBtn.addTarget(self, action: #selector(requestDeleteAccount), for: .touchUpInside)
    }
 
    @objc private func requestDeleteAccount() {
        _Concurrency.Task {
            do {
                let response: () = try await networkService.deleteAccount()
                print("회원 탈퇴 성공: \(response)")
                self.logoutAndRedirectToOnboarding()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func logoutAndRedirectToOnboarding() {
        DispatchQueue.main.async {
            // ✅ Keychain에서 저장된 토큰 삭제
            KeychainManager.shared.delete(key: "accessToken")
            KeychainManager.shared.delete(key: "refreshToken")
            
            // ✅ 로그인 화면으로 이동
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else {
                print("❌ 윈도우 찾기 실패")
                return
            }
            
            let onboardingVC = OnBoardingViewController()
            let navController = UINavigationController(rootViewController: onboardingVC)
            
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
