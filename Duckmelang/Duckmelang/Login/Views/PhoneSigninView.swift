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
        paragraphStyle.lineHeightMultiple = 1.35 //자간 135%

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
        paragraphStyle.lineHeightMultiple = 1.6 //자간 160%

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
    
    public lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 스타일 설정
        textField.font = UIFont.ptdRegularFont(ofSize: 15)
        textField.textColor = UIColor.grey600
        
        // 플레이스홀더 설정
        textField.placeholder = "01012345678"
        
        // 왼쪽 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        // 사용자 입력 가능하도록 설정
        textField.isUserInteractionEnabled = true
        
        // 테두리 설정
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.grey400!.cgColor
        
        return textField
    }()
    
    public let verifyButton = UIButton().then {
        $0.setTitle("인증 요청", for: .normal)
        $0.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 13)
        $0.setTitleColor(.grey100, for: .normal)
        $0.backgroundColor = UIColor.dmrBlue
        $0.layer.cornerRadius = 8
    }
    
    private let phoneVerifyContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var certificationNumberField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 스타일 설정
        textField.font = UIFont.ptdRegularFont(ofSize: 15)
        textField.textColor = UIColor.grey600
        
        //FIXME: - 인증시간 Count
        // 플레이스홀더 설정
        textField.placeholder = "(인증시간 Count)"
        
        // 왼쪽 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        // 사용자 입력 가능하도록 설정
        textField.isUserInteractionEnabled = true
        
        // 테두리 설정
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.grey400!.cgColor
        
        return textField
    }()
    
    public let verifyCodeButton = UIButton().then {
        $0.setTitle("인증", for: .normal)
        $0.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 13)
        $0.setTitleColor(.grey100, for: .normal)
        $0.backgroundColor = UIColor.dmrBlue
        $0.layer.cornerRadius = 8
    }
    
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
        
        verifyCodeContainer.snp.makeConstraints {
            $0.top.equalTo(phoneVerifyContainer.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
        }
        
        verifyButton.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.width.equalTo(65)
        }

        certificationNumberField.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
        }
        
        verifyCodeButton.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.width.equalTo(65)
        }
        
        
    }
}
