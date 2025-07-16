//
//  WarningPopupViewController.swift
//  Duckmelang
//
//  Created by nau on 6/30/25.
//

import UIKit

class WarningPopupViewController: UIViewController {
    
    var nickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = popupView
    }
    
    private lazy var popupView = noImageCustomPopupView(title: "\(nickname!)님의 게시글을 신고하였습니다.", subTitle: "", leftBtnTitle: "", rightBtnTitle: "").then {
        $0.leftBtn.isHidden = true
        $0.rightBtn.isHidden = true
    }
}
