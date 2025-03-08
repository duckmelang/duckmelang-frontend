//
//  LogoutPopupViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/20/25.
//

import UIKit
import Moya

class LogoutPopupViewController: UIViewController {
    
    private let providerLogout = MoyaProvider<LoginAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = logoutPopupView
    }
    
    private lazy var logoutPopupView = noImageCustomPopupView(title: "정말 로그아웃 하시겠습니까?", subTitle: "", leftBtnTitle: "아니요", rightBtnTitle: "네", height: 150).then {
        $0.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        $0.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
    }
    
    @objc private func leftBtnTap() {
        print("취소")
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func rightBtnTap() {
        print("로그아웃")
        logout()
    }
    
    // ✅ 로그아웃 API 요청
    private func logout() {
        providerLogout.request(.postLogout) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<String>.self)
                    if decodedResponse.isSuccess {
                        print("✅ 로그아웃 성공: \(decodedResponse.message)")
                        
                        // ✅ 토큰 삭제 후 로그인 화면으로 이동
                        KeychainManager.shared.delete(key: "accessToken")
                        KeychainManager.shared.delete(key: "refreshToken")
                        DispatchQueue.main.async {
                            self.goToLoginScreen()
                        }
                    } else {
                        print("❌ 로그아웃 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // ✅ 로그인 화면으로 이동
    private func goToLoginScreen() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
