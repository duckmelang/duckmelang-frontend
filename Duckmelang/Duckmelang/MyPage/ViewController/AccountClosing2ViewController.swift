//
//  AccountClosing2ViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class AccountClosing2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = accountClosing2View
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var accountClosing2View = AccountClosing2View().then {
        $0.outBtn.addTarget(self, action: #selector(outBtnDidTap), for: .touchUpInside)
    }
 
    @objc
    private func outBtnDidTap() {
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false)
    }

}
