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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    // description Label
    private let descriptionLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.6 // 자간 160%

        let attributedString = NSAttributedString(
            string: "아이디는 영문/숫자 조합의 4~10자,\n비밀번호는 영문+숫자 포함 8자 이상으로 입력해주세요.",
            attributes: [
                .font: UIFont.ptdRegularFont(ofSize: 12),
                .foregroundColor: UIColor.grey600!,
                .paragraphStyle: paragraphStyle
            ]
        )

        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    
    // ID Label
    private let idLabel = UILabel().then {
        $0.text = "ID"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = UIColor.grey700
    }
    
    // ID TextField
    public let idTextField = CustomTextField(placeholder: "아이디를 입력해주세요")
    
    // ID Button
    public let idButton = SignupButton(title: "중복 확인")
    
    // ID Verify Container
    public lazy var idVerifyContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    // ID Container
    private let idContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
    }
    
    // 사용할 수 있는 아이디일 때 문구
    public lazy var successLabel = UILabel().then {
        $0.text = "사용 가능한 아이디입니다."
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = UIColor(hex: "#4CAF50")
        $0.isHidden = true
    }
    
    // 중복 아이디일 때 경고 문구
    public lazy var idAlertLabel = UILabel().then {
        $0.text = "이미 사용 중인 아이디입니다. 다른 아이디를 입력해주세요."
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .errorPrimary
        $0.isHidden = true
    }
    
    // PW Label
    private let pwLabel = UILabel().then {
        $0.text = "PW"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = UIColor.grey700
    }
    
    // PW TextField
    public let pwTextField = CustomTextField(placeholder: "비밀번호를 입력해주세요")
    
    // PW Container
    private let pwContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
    }
    
    // 비밀번호 조합이 맞지 않을 때 경고 문구
    public lazy var pwAlertLabel = UILabel().then {
        $0.text = "영문, 숫자를 조합해 8자리 이상 작성해주세요"
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .errorPrimary
        $0.isHidden = true
    }
    
    public let signUpButton = longCustomBtn(title: "확인", isEnabled: false)
    
    private func setupView() {
        // ID Verify Container 내부 요소 추가
        idVerifyContainer.addArrangedSubview(idTextField)
        idVerifyContainer.addArrangedSubview(idButton)
        
        // ID Container 내부 요소 추가
        idContainer.addArrangedSubview(idLabel)
        idContainer.addArrangedSubview(idVerifyContainer)
        
        // PW Container 내부 요소 추가
        pwContainer.addArrangedSubview(pwLabel)
        pwContainer.addArrangedSubview(pwTextField)
        
        [
            titleLabel,
            descriptionLabel,
            idContainer,
            successLabel,
            idAlertLabel,
            pwContainer,
            signUpButton,
            pwAlertLabel
        ].forEach {
            addSubview($0)
        }
        
        // 레이아웃 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        idContainer.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(idTextField.snp.bottom)
        }
        
        successLabel.snp.makeConstraints {
            $0.top.equalTo(idContainer.snp.bottom).offset(4)
            $0.leading.equalTo(idContainer).offset(4)
        }
        
        idAlertLabel.snp.makeConstraints {
            $0.top.equalTo(idContainer.snp.bottom).offset(4)
            $0.leading.equalTo(idContainer).offset(4)
        }
        
        pwContainer.snp.makeConstraints {
            $0.top.equalTo(idContainer.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(pwTextField.snp.bottom)
        }
        
        pwAlertLabel.snp.makeConstraints {
            $0.top.equalTo(pwContainer.snp.bottom).offset(4)
            $0.leading.equalTo(pwContainer).offset(4)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(pwContainer.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
