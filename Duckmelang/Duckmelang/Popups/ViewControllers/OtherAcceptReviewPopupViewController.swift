//
//  OtherAcceptReviewPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class OtherAcceptReviewPopupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = otherAcceptReviewPopupViewController
    }
    
    private lazy var otherAcceptReviewPopupViewController: CustomPopupView = {
        let view = CustomPopupView(userImage: UIImage(), title: "유저 님이 나와의 동행을 확정했어요!", subTitle: "후기를 작성해야만 다음 동행 상대를 구할 수 있습니다", leftBtnTitle: "", rightBtnTitle: "후기 작성하기", height: 220)
        
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
