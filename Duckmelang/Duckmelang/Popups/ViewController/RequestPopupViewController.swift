//
//  RequestPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class RequestPopupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = requestPopupViewController
    }
    
    private lazy var requestPopupViewController: CustomPopupView = {
        let view = CustomPopupView(userImage: UIImage(), title: "유저 님이 동행 확정 요청을 보냈어요", subTitle: "거절 후에는 취소할 수 없어요", leftBtnTitle: "거절", rightBtnTitle: "수락", height: 220)
        
        view.panel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        view.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        view.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func closeModal() {
        dismiss(animated: false)
    }
    
    @objc private func leftBtnTap() {
        // TODO: 동행 거절하기
        print("거절")
        closeModal()
    }
    
    @objc private func rightBtnTap() {
        // TODO: 동행 수락하기
        print("수락")
    }
}
