//
//  FoundPasswordView.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

class FoundPasswordView: UIView {
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
            string: "아이디를 입력해주세요",
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
            string: "기존 덕메랑에 저장된 아이디로 비밀번호를 찾아드릴게요",
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
    
    public lazy var idTextField = CustomTextField(placeholder: "아이디를 입력해주세요")
    
    public lazy var verifyButton = SignupButton(title: "확인")
    
    private let idContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var alertLabel = UILabel().then {
        $0.text = "입력하신 아이디를 찾을 수 없어요. 확인 후 다시 시도해주세요."
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .errorPrimary
        $0.isHidden = true
    }
    
    private func setupView() {
        topLabelContainer.addArrangedSubview(titleLabel)
        topLabelContainer.addArrangedSubview(descriptionLabel)
        
        idContainer.addArrangedSubview(idTextField)
        idContainer.addArrangedSubview(verifyButton)
        
        [
            topLabelContainer,
            idContainer,
            alertLabel
        ].forEach {
            addSubview($0)
        }
        
        topLabelContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        idContainer.snp.makeConstraints {
            $0.top.equalTo(topLabelContainer.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        alertLabel.snp.makeConstraints{
            $0.top.equalTo(idContainer.snp.bottom).offset(4)
            $0.leading.equalTo(idContainer.snp.leading).offset(4)
        }
    }
}
