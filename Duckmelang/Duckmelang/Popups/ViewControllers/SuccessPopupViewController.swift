//
//  SuccessPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class SuccessPopupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = successPopupViewController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismissAllPopups()
        }
    }
    
    private lazy var successPopupViewController: CustomPopupView = {
        let view = CustomPopupView(userImage: UIImage(), title: "유저 님에게 동행 확정 요청을 보냈어요", subTitle: "", leftBtnTitle: "", rightBtnTitle: "", height: 123)
        return view
    }()
    
    @objc private func dismissAllPopups() {
        dismiss(animated: false)
    }
}
