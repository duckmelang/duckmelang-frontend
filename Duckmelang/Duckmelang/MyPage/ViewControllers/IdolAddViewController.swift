//
//  IdolAddViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class IdolAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = idolAddView
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var idolAddView = IdolAddView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
}
