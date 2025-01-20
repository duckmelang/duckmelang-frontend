//
//  ChatViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = chatView
        
    }
    
    private lazy var chatView: ChatView = {
        let view = ChatView()
        view.btn.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        view.btn1.addTarget(self, action: #selector(button1DidTap), for: .touchUpInside)
        view.btn2.addTarget(self, action: #selector(button2DidTap), for: .touchUpInside)
        view.btn3.addTarget(self, action: #selector(button3DidTap), for: .touchUpInside)
        return view
    }()
    
    @objc private func buttonDidTap() {
        let popupVC = RequestPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
    @objc private func button1DidTap() {
        let popupVC = ConfirmPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
    @objc private func button2DidTap() {
        let popupVC = OtherAcceptReviewPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
    @objc private func button3DidTap() {
        let popupVC = MyAcceptReviewPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
}
