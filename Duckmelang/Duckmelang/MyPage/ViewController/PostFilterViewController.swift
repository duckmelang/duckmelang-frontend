//
//  PostFilterViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/5/25.
//

import UIKit

class PostFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = postFilterView
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var postFilterView = PostFilterView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
}
