//
//  FeedManagementViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class FeedManagementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = feedManagementView
        
        navigationController?.isNavigationBarHidden = true
        
        setupAction()
    }
    
    private lazy var feedManagementView = FeedManagementView()

    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func finishBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    private func setupAction() {
        feedManagementView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        feedManagementView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
    }
}
