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
        $0.textColor = .grey800
        $0.keyboardType = .default
        $0.returnKeyType = .done
    }
    
    public let nickCheckButton = UIButton().then {
        $0.configureGenderButton(title: "확인", selectedBool: false)
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
        $0.placeholder = "YYYY-MM-DD"
        $0.borderStyle = .none
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.tintColor = .clear
    }
    
    private let birthdateUnderline = UIView().then {
        $0.backgroundColor = .grey300
    }
    
    public let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko-KR")
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = .grey700
    }
    
    public let maleButton = UIButton().then {
        $0.configureGenderButton(title: "남성", selectedBool: false)
    }

    public let femaleButton = UIButton().then {
        $0.configureGenderButton(title: "여성", selectedBool: true)
    }
    
    
    // MARK: - Containers
    private lazy var nicknameContainer = UIView().then {
        $0.addSubview(nicknameLabel)
        $0.addSubview(nicknameTextField)
        $0.addSubview(nicknameUnderline)
        $0.addSubview(nickCheckButton)
    }
        
    private lazy var birthdateContainer = UIView().then {
        $0.addSubview(birthdateLabel)
        $0.addSubview(birthdateTextField)
        $0.addSubview(birthdateUnderline)
    }
    
    private lazy var genderContainer = UIView().then {
        $0.addSubview(genderLabel)
        $0.addSubview(maleButton)
        $0.addSubview(femaleButton)
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 26
        $0.alignment = .fill
        $0.addArrangedSubview(nicknameContainer)
        $0.addArrangedSubview(birthdateContainer)
        $0.addArrangedSubview(genderContainer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        nicknameTextField.delegate = self
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
        
        nicknameContainer.snp.makeConstraints{
            $0.bottom.equalTo(nicknameUnderline)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
                
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(nickCheckButton.snp.leading)
            $0.height.equalTo(40)
        }
        
        nickCheckButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(nicknameTextField)
        }
                
        nicknameUnderline.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(2)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        birthdateContainer.snp.makeConstraints{
            $0.bottom.equalTo(birthdateUnderline)
        }
        
        birthdateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
                
        birthdateTextField.snp.makeConstraints {
            $0.top.equalTo(birthdateLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
                
        birthdateUnderline.snp.makeConstraints {
            $0.top.equalTo(birthdateTextField.snp.bottom).offset(2)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        genderContainer.snp.makeConstraints{
            $0.bottom.equalTo(maleButton)
        }
        
        genderLabel.snp.makeConstraints {
            $0.centerY.equalTo(maleButton)
            $0.leading.equalToSuperview()
        }
                        
        maleButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(femaleButton.snp.leading).offset(-8)
        }
        
        femaleButton.snp.makeConstraints {
            $0.centerY.equalTo(maleButton)
            $0.trailing.equalToSuperview()
        }
    }
}

extension UIButton {
    func configureGenderButton(title: String, selectedBool: Bool) {
        self.isSelected = selectedBool
        self.titleLabel?.font = .ptdSemiBoldFont(ofSize: 14)
        self.setTitle(title, for: .normal)
        self.setTitleColor(selectedBool ? .white : .grey400, for: .normal)
        self.backgroundColor = selectedBool ? .dmrBlue : .white
        self.layer.borderWidth = 1
        self.layer.borderColor = selectedBool ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
        self.layer.cornerRadius = 15
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

extension SetupNickBirthGenView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
