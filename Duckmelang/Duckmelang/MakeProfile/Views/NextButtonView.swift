//
//  NextButtonView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import SnapKit

class NextButtonView: UIView {
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
    }
    
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
            $0.edges.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}
