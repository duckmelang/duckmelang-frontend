//
//  LoginInfoViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class LoginInfoViewController: UIViewController {
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = loginInfoView
        
        navigationController?.isNavigationBarHidden = true
        
        getLoginInfo()
    }

    private lazy var loginInfoView = LoginInfoView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    private func getLoginInfo() {
        provider.request(.getMyPageLogin) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<myPageLoginResponse>.self)
                    guard let loginInfo = decodedResponse.result else {
                        print("❌ 로그인정보가 없습니다.")
                        return
                    }

                    // UI 업데이트는 반드시 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        self.loginInfoView.loginInfo = loginInfo
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("❌ 프로필 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}
