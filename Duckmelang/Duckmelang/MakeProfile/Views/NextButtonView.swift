//
//  NextButtonView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import SnapKit

class NextButtonView: UIView {
    
    let nextButton = longCustomBtn(title: "다음")
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(nextButton)
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
        }
    }
}
