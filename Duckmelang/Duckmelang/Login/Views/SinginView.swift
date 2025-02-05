//
//  navigateToIDPWView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Then
import SnapKit

class SinginView: UIView {
    
    // Title Label
    private let titleLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.35 // 자간 135%

        let attributedString = NSAttributedString(
            string: "ID / PW를 입력해주세요",
            attributes: [
                .font: UIFont.aritaBoldFont(ofSize: 20),
                .foregroundColor: UIColor.grey800!,
                .paragraphStyle: paragraphStyle
            ]
        )
        $0.attributedText = attributedString
    }
    
    // ID Label
    private let idLabel = UILabel().then {
        $0.text = "ID"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = UIColor.grey700
    }
    
    // ID TextField
    private let idTextField = UITextField().then {
        $0.placeholder = "아이디를 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
    }
    
    // ID Container
    private let idContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
    }
    
    // PW Label
    private let pwLabel = UILabel().then {
        $0.text = "PW"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = UIColor.grey700
    }
    
    // PW TextField
    private let pwTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = false
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
    }
    
    // PW Container
    private let pwContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
    }
    
    public let signUpButton = longCustomBtn(title: "확인")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // ID Container 내부 요소 추가
        idContainer.addArrangedSubview(idLabel)
        idContainer.addArrangedSubview(idTextField)
        
        // PW Container 내부 요소 추가
        pwContainer.addArrangedSubview(pwLabel)
        pwContainer.addArrangedSubview(pwTextField)
        
        [
            titleLabel,
            idContainer,
            pwContainer,
            signUpButton
        ].forEach {
            addSubview($0)
        }
        
        // 레이아웃 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.left.equalToSuperview().offset(16)
        }
        
        idContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        pwContainer.snp.makeConstraints {
            $0.top.equalTo(idContainer.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        idTextField.snp.makeConstraints{
            $0.height.equalTo(40)
        }
        
        pwTextField.snp.makeConstraints{
            $0.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(pwContainer.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
}
