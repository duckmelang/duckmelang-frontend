//
//  AccountClosing1ViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class AccountClosing1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = accountClosing1View
        
        navigationController?.isNavigationBarHidden = true
    }

    private lazy var accountClosing1View = AccountClosing1View().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
}
