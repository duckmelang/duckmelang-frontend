//
//  CheckNicknamePopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 4/2/25.
//

import UIKit

class CheckNicknamePopupViewController: UIViewController {
    var isAvailable: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isAvailable == true {
            let popupView = noImageCustomPopupView(
                title: "닉네임 확인",
                subTitle: "사용 가능한 닉네임입니다.",
                subTitleColor: .grey800 ?? .gray,
                rightBtnTitle: "확인"
            )
            popupView.rightBtn.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
            self.view = popupView
        } else {
            let popupView = noImageCustomPopupView(
                title: "닉네임 확인",
                subTitle: "중복된 닉네임입니다.",
                subTitleColor: .errorPrimary ?? .red,
                rightBtnTitle: "확인"
            )
            popupView.rightBtn.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
            self.view = popupView
        }
    }
    
    @objc private func dismissPopup() {
        dismiss(animated: false)
    }
}
