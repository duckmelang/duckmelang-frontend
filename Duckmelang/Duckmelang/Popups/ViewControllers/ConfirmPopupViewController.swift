//
//  ConfirmPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class ConfirmPopupViewController: UIViewController {
    weak var delegate: ModalDelegate?
    
    protocol ModalDelegate: AnyObject {
        func hideConfirmBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = confirmPopupViewController
    }
    
    private lazy var confirmPopupViewController: CustomPopupView = {
        let view = CustomPopupView(userImage: UIImage(), title: "유저 님과의 동행을 확정할까요?", subTitle: "", leftBtnTitle: "취소", rightBtnTitle: "확정", height: 200)
        
        view.panel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        view.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        view.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func closeModal() {
        dismiss(animated: false)
    }
    
    @objc private func leftBtnTap() {
        // TODO: 동행 취소시키기
        print("동행 취소")
        closeModal()
    }
    
    @objc private func rightBtnTap() {
        // TODO: 동행 확정시키기
        print("동행 확정")
        delegate?.hideConfirmBtn()
        
        // 두 번째 팝업 생성 및 표시
        if let presentingVC = self.presentingViewController {
            self.dismiss(animated: false) {
                let successPopupVC = SuccessPopupViewController()
                successPopupVC.modalPresentationStyle = .overFullScreen
                presentingVC.present(successPopupVC, animated: false, completion: nil)
            }
        }
    }
}
