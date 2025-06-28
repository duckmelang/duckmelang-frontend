//
//  LoginInfoViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class LoginInfoViewController: UIViewController {
    
    let networkService = MyPageService()
 
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
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getLoginInfo() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let response = try await self.networkService.getMyPageLogin()
                DispatchQueue.main.async {
                    self.loginInfoView.loginInfo = response
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
}
