//
//  MakeProfileView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class MakeProfileView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필을 작성해볼까요?"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
    }
    
    private let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임 입력"
        $0.borderStyle = .roundedRect
    }
    
    private let birthdateTextField = UITextField().then {
        $0.placeholder = "생년월일 (YYYYMMDD)"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
    }
    
    private let genderSegmentedControl = UISegmentedControl(items: ["남성", "여성"]).then {
        $0.selectedSegmentIndex = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            nicknameTextField,
            birthdateTextField,
            genderSegmentedControl
        ].forEach {
            addSubview($0)
        }
            
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
            
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
            
        birthdateTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
            
        genderSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(birthdateTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
        }
    }
}
