//
//  ProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class ProfileModifyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileModifyView
        
        navigationController?.isNavigationBarHidden = true
        
        setupAction()
    }
    
    private lazy var profileModifyView = ProfileModifyView()

    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func finishBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    private func setupAction() {
        profileModifyView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        profileModifyView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
    }
}
