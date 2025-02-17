//
//  SetupNickBirthGenView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class SetupNickBirthGenView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필을 작성해볼까요?"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    
    private let profileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "profileAddPlaceholder"), for: .normal)
        $0.backgroundColor = .grey300
        $0.layer.cornerRadius = 45
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = .grey700
    }
    
    public let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임 입력"
        $0.borderStyle = .none
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
    }
    
    private let nicknameUnderline = UIView().then {
        $0.backgroundColor = .grey300
    }
    
    private let birthdateLabel = UILabel().then {
        $0.text = "생년월일"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = .grey700
    }
    
    public let birthdateTextField = UITextField().then {
        $0.placeholder = "YYYYMMDD"
        $0.borderStyle = .none
        $0.keyboardType = .numberPad
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
    }
    
    private let birthdateUnderline = UIView().then {
        $0.backgroundColor = .grey300
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = .grey700
    }
    
    public let genderSegmentedControl = UISegmentedControl(items: ["남성", "여성"]).then {
        $0.selectedSegmentIndex = 1
        $0.setTitleTextAttributes([.foregroundColor: UIColor.grey700!], for: .normal)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.white!], for: .selected)
        $0.selectedSegmentTintColor = .dmrBlue
    }
    
    // MARK: - Containers
    private lazy var nicknameContainer = UIView().then {
        $0.addSubview(nicknameLabel)
        $0.addSubview(nicknameTextField)
        $0.addSubview(nicknameUnderline)
    }
        
    private lazy var birthdateContainer = UIView().then {
        $0.addSubview(birthdateLabel)
        $0.addSubview(birthdateTextField)
        $0.addSubview(birthdateUnderline)
    }
    
    private lazy var genderContainer = UIView().then {
        $0.addSubview(genderLabel)
        $0.addSubview(genderSegmentedControl)
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.addArrangedSubview(nicknameContainer)
        $0.addArrangedSubview(birthdateContainer)
        $0.addArrangedSubview(genderContainer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            profileImageButton,
            mainStackView
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
        }
                
        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(95)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
                
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.height.equalTo(40)
        }
                
        nicknameUnderline.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(2)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        birthdateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
                
        birthdateTextField.snp.makeConstraints {
            $0.top.equalTo(birthdateLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.height.equalTo(40)
        }
                
        birthdateUnderline.snp.makeConstraints {
            $0.top.equalTo(birthdateTextField.snp.bottom).offset(2)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        genderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
                        
        genderSegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
}
