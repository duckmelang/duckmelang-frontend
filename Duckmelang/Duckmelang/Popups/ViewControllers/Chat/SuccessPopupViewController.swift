//
//  SuccessPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class SuccessPopupViewController: UIViewController {
    var oppositeNickname: String?
    var oppositeProfileImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = successPopupViewController
        
        guard let oppositeProfileImage = self.oppositeProfileImage else { return }
        if let oppositeProfileImageUrl = URL(string: oppositeProfileImage) {
            successPopupViewController.userImage.kf.setImage(with: oppositeProfileImageUrl, placeholder: UIImage())
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismissAllPopups()
        }
    }
    
    private lazy var successPopupViewController: CustomPopupView = {
        let view = CustomPopupView(userImage: UIImage(), title: "\(self.oppositeNickname ?? "유저") 님에게 동행 확정 요청을 보냈어요", subTitle: "", leftBtnTitle: "", rightBtnTitle: "")
        return view
    }()
    
    @objc private func dismissAllPopups() {
        dismiss(animated: false)
    }
}
