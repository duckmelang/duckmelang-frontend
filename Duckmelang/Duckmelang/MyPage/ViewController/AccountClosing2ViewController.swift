//
//  AccountClosing2ViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class AccountClosing2ViewController: UIViewController {
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = accountClosing2View
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var accountClosing2View = AccountClosing2View().then {
        $0.outBtn.addTarget(self, action: #selector(requestDeleteAccount), for: .touchUpInside)
    }
 
    @objc private func requestDeleteAccount() {
           provider.request(.deleteAccount) { result in
               switch result {
               case .success(let response):
                   do {
                       let decodedResponse = try response.map(ApiResponse<String>.self)
                       if decodedResponse.isSuccess {
                           print("✅ 회원 탈퇴 성공: \(decodedResponse.message)")
                           self.logoutAndRedirectToOnboarding()
                       } else {
                           print("❌ 회원 탈퇴 실패: \(decodedResponse.message)")
                       }
                   } catch {
                       print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                   }
               case .failure(let error):
                   print("❌ 요청 실패: \(error.localizedDescription)")
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
