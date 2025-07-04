//
//  WarningPopupViewController.swift
//  Duckmelang
//
//  Created by nau on 6/30/25.
//

import UIKit

class WarningPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = popupView
    }
    
    private lazy var popupView = noImageCustomPopupView(title: "님의 게시글을 신고하였습니다.", subTitle: "", leftBtnTitle: "", rightBtnTitle: "")

}
