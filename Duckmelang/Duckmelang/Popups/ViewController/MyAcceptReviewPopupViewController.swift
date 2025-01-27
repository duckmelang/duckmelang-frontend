//
//  MyAcceptReviewPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class MyAcceptReviewPopupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myAcceptReviewPopupViewController
    }
    
    private lazy var myAcceptReviewPopupViewController: CustomPopupView = {
        let view = CustomPopupView(userImage: UIImage(), title: "유저 님과의 동행은 어떠셨나요?\n후기를 남겨주세요!", subTitle: "후기를 작성해야만 다음 동행 상대를 구할 수 있습니다", leftBtnTitle: "", rightBtnTitle: "후기 작성하기", height: 230)
        
        view.panel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        view.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func closeModal() {
        dismiss(animated: false)
    }
    
    @objc private func rightBtnTap() {
        // TODO: 후기 작성으로 이동
        print("후기 작성")
    }
}
