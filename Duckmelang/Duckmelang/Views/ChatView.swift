//
//  ChatView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/19/25.
//

import UIKit

class ChatView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 팝업창 열리는 지 확인하기 위한 임시 버튼들
    let btn = smallFilledCustomBtn(title: "동행 확정 요청 열기")
    let btn1 = smallFilledCustomBtn(title: "동행 확정 열기")
    let btn2 = smallFilledCustomBtn(title: "상대방 수락 후기 작성")
    let btn3 = smallFilledCustomBtn(title: "내가 수락 후기 작성")
    
    let btnStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    func setupView() {
        btnStack.addArrangedSubview(btn)
        btnStack.addArrangedSubview(btn1)
        btnStack.addArrangedSubview(btn2)
        btnStack.addArrangedSubview(btn3)
        addSubview(btnStack)
        
        btnStack.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
