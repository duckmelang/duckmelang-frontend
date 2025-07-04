//
//  SignupButton.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

class SignupButton: UIButton {
    
    // MARK: - Initializer
    init(title: String) {
        super.init(frame: .zero)
        setupStyle()
        setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    // MARK: - Setup
    private func setupStyle() {
        self.setTitleColor(.grey100, for: .normal)
        self.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 13)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.backgroundColor = .dmrBlue
        self.isEnabled = false
        
        // 크기 고정
        self.snp.makeConstraints {
            $0.width.equalTo(65)
            $0.height.equalTo(40)
        }
    }

    // MARK: - 상태 변경 감지
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .dmrBlue : .grey400
        }
    }
}
