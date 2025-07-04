//
//  PhoneSigninView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Then
import SnapKit

class PhoneSigninView: UIView {
    
    private let titleLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.35 // 자간 135%

        let attributedString = NSAttributedString(
            string: "반가워요!\n휴대폰 번호로 가입해주세요",
            attributes: [
                .font: UIFont.aritaBoldFont(ofSize: 20),
                .foregroundColor: UIColor.grey800!,
                .paragraphStyle: paragraphStyle
            ]
        )

        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    
    private let descriptionLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.6 // 자간 160%

        let attributedString = NSAttributedString(
            string: "덕메랑은 휴대폰 번호로 가입해요.\n번호는 안전하게 보관되며 어디에도 공개되지 않아요.",
            attributes: [
                .font: UIFont.ptdRegularFont(ofSize: 12),
                .foregroundColor: UIColor.grey600!,
                .paragraphStyle: paragraphStyle
            ]
        )

        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    
    private let topLabelContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 12
    }
    
    public lazy var phoneTextField = CustomTextField(placeholder: "전화번호를 입력해주세요", keyboardType: .numberPad)
    
    public let verifyButton = SignupButton(title: "인증 요청")
    
    public lazy var alertLabel = UILabel().then {
        $0.text = "이미 가입된 전화번호입니다. 다른 번호로 시도해주세요."
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .errorPrimary
        $0.isHidden = true
    }
    
    public lazy var phoneVerifyContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var certificationNumberField = CustomTextField(placeholder: "(인증시간 Count)", keyboardType: .numberPad)
    
    public let verifyCodeButton = SignupButton(title: "확인")
    
    public let verifyCodeContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
        $0.isHidden = true
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
        topLabelContainer.addArrangedSubview(titleLabel)
        topLabelContainer.addArrangedSubview(descriptionLabel)
        
        phoneVerifyContainer.addArrangedSubview(phoneTextField)
        phoneVerifyContainer.addArrangedSubview(verifyButton)
        
        verifyCodeContainer.addArrangedSubview(certificationNumberField)
        verifyCodeContainer.addArrangedSubview(verifyCodeButton)
        
        [
            topLabelContainer,
            phoneVerifyContainer,
            alertLabel,
            verifyCodeContainer
        ].forEach {
            addSubview($0)
        }
        
        topLabelContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(descriptionLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneVerifyContainer.snp.makeConstraints {
            $0.top.equalTo(topLabelContainer.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(phoneVerifyContainer.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        
        verifyCodeContainer.snp.makeConstraints {
            $0.top.equalTo(phoneVerifyContainer.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
