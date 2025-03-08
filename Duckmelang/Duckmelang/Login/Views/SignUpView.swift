//
//  navigateToIDPWView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Then
import SnapKit

class SignUpView: UIView {
    
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
    
    // EMAIL Label
    private let emailLabel = UILabel().then {
        $0.text = "EMAIL"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = UIColor.grey700
    }
    
    // EMAIL TextField
    public let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
    }
    
    // EMAIL Container
    private let emailContainer = UIStackView().then {
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
    public let pwTextField = UITextField().then {
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
        emailContainer.addArrangedSubview(emailLabel)
        emailContainer.addArrangedSubview(emailTextField)
        
        // PW Container 내부 요소 추가
        pwContainer.addArrangedSubview(pwLabel)
        pwContainer.addArrangedSubview(pwTextField)
        
        [
            titleLabel,
            emailContainer,
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
        
        emailContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(emailTextField.snp.bottom)
        }
        
        pwContainer.snp.makeConstraints {
            $0.top.equalTo(emailContainer.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(pwTextField.snp.bottom)
        }
        
        emailTextField.snp.makeConstraints{
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
