//
//  VerifyPhoneView.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit

class VerifyPhoneView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.35 // 자간 135%

        let attributedString = NSAttributedString(
            string: "휴대폰 번호를 입력해주세요",
            attributes: [
                .font: UIFont.aritaBoldFont(ofSize: 20),
                .foregroundColor: UIColor.grey800!,
                .paragraphStyle: paragraphStyle
            ]
        )

        $0.attributedText = attributedString
    }
    
    private let descriptionLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.6 // 자간 160%

        let attributedString = NSAttributedString(
            string: "기존 덕메랑에 저장된 휴대폰 번호로 비밀번호를 찾아드릴게요",
            attributes: [
                .font: UIFont.ptdRegularFont(ofSize: 12),
                .foregroundColor: UIColor.grey600!,
                .paragraphStyle: paragraphStyle
            ]
        )

        $0.attributedText = attributedString
    }
    
    private let topLabelContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    public lazy var phoneTextField = CustomTextField(placeholder: "전화번호를 입력해주세요", keyboardType: .numberPad)
    
    public lazy var verifyButton = SignupButton(title: "인증 요청")
    
    public let phoneVerifyContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var certificationNumberField = CustomTextField(placeholder: "(인증시간 Count)", keyboardType: .numberPad)
    
    public let verifyCodeButton = SignupButton(title: "인증")
    
    public let verifyCodeContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
        $0.isHidden = true
    }
    
    private func setupView() {
        topLabelContainer.addArrangedSubview(titleLabel)
        topLabelContainer.addArrangedSubview(descriptionLabel)
        
        phoneVerifyContainer.addArrangedSubview(phoneTextField)
        phoneVerifyContainer.addArrangedSubview(verifyButton)
        
        verifyCodeContainer.addArrangedSubview(certificationNumberField)
        verifyCodeContainer.addArrangedSubview(verifyCodeButton)
        
        [
            topLabelContainer,
            phoneVerifyContainer,
            verifyCodeContainer
        ].forEach {
            addSubview($0)
        }
        
        topLabelContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        phoneVerifyContainer.snp.makeConstraints {
            $0.top.equalTo(topLabelContainer.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        verifyCodeContainer.snp.makeConstraints {
            $0.top.equalTo(phoneVerifyContainer.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

