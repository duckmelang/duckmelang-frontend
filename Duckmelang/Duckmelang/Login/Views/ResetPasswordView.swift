//
//  ResetPasswordView.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit

class ResetPasswordView: UIView {
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
            string: "이메일을 입력해주세요",
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
            string: "기존 덕메랑에 저장된 이메일로 비밀번호를 찾아드릴게요",
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
    
    public lazy var emailTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 스타일 설정
        textField.font = UIFont.ptdRegularFont(ofSize: 15)
        textField.textColor = UIColor.grey700
        
        // 플레이스홀더 설정
        textField.placeholder = "이메일을 입력해주세요"
        
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
    
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    public lazy var verifyButton = smallFilledCustomBtn(
        title: "확인",
        titleColor: .grey100!,
        font: .ptdSemiBoldFont(ofSize: 13),
        radius: 5,
        isEnabled: false,
        width: 65,
        height: 40
    )
    
    private let phoneVerifyContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var alertLabel = UILabel().then {
        $0.text = "입력하신 이메일을 찾을 수 없어요. 확인 후 다시 시도해주세요."
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .errorPrimary
        $0.isHidden = true
    }
    
    private func setupView() {
        topLabelContainer.addArrangedSubview(titleLabel)
        topLabelContainer.addArrangedSubview(descriptionLabel)
        
        phoneVerifyContainer.addArrangedSubview(emailTextField)
        phoneVerifyContainer.addArrangedSubview(verifyButton)
        
        [
            topLabelContainer,
            phoneVerifyContainer,
            alertLabel
        ].forEach {
            addSubview($0)
        }
        
        topLabelContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneVerifyContainer.snp.makeConstraints {
            $0.top.equalTo(topLabelContainer.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.equalToSuperview()
        }
        
        verifyButton.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.width.equalTo(65)
        }
        
        alertLabel.snp.makeConstraints{
            $0.top.equalTo(phoneVerifyContainer.snp.bottom).offset(4)
            $0.leading.equalTo(phoneVerifyContainer.snp.leading)
        }
    }
}
