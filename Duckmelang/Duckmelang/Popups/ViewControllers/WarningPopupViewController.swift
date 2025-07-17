//
//  WarningPopupViewController.swift
//  Duckmelang
//
//  Created by nau on 6/30/25.
//

import UIKit

class WarningPopupViewController: UIViewController {
    
    var nickname: String?
    var reportTargetType: ReportTargetType = .post // 기본값은 게시글

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = popupView
    }
    
    private lazy var popupView: noImageCustomPopupView = {
        let title: String
        
        switch reportTargetType {
        case .post:
            title = "\(nickname!)님의 \n 게시글을 신고하였습니다."
        case .review:
            title = "\(nickname!)님의 \n 동행후기를 신고하였습니다."
        }
        
        return noImageCustomPopupView(title: title, subTitle: "", leftBtnTitle: "", rightBtnTitle: "")
    }().then {
        $0.leftBtn.isHidden = true
        $0.rightBtn.isHidden = true
    }
}

enum ReportTargetType {
    case post
    case review
}
