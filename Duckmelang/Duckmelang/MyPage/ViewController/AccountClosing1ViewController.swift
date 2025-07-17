//
//  AccountClosing1ViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class AccountClosing1ViewController: UIViewController {
    
    let networkService = LoginService()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = accountClosing1View
        
        navigationController?.isNavigationBarHidden = true
    }

    private lazy var accountClosing1View = AccountClosing1View().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.outBtn.addTarget(self, action: #selector(outBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func outBtnDidTap() {
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
            // Keychain에서 저장된 토큰 삭제
            KeychainManager.shared.delete(key: "accessToken")
            KeychainManager.shared.delete(key: "refreshToken")
            
            let vc = UINavigationController(rootViewController: AccountClosing2ViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
