//
//  PostDetailViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class PostDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = postDetailView
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var postDetailView = PostDetailView()
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }

}
