//  LoginView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SnapKit
import Then

class LoginView: UIView {

    var iconClick = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private lazy var logoImageView: UIImageView = {
        return createImageView(named: "logo_yellow")
    }()
    
    private lazy var idView: UIView = {
        let view = UIView()
        view.addSubview(idTextField)
        idTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        return view
    }()
    
    public lazy var idTextField = CustomTextField(placeholder: "아이디")
    
    private lazy var pwdView: UIView = {
        let view = UIView()
        view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        return view
    }()
    
    public lazy var pwdTextField = CustomTextField(placeholder: "비밀번호").then {
        let eyeButton = UIButton(type: .custom)
        
        let eyeSlash = UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate)
        let eyeOpen = UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate)
        
        eyeButton.setImage(eyeSlash, for: .normal)
        eyeButton.setImage(eyeOpen, for: .selected)
        
        eyeButton.tintColor = UIColor.grey800
        
        eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        eyeButton.addTarget(self, action: #selector(iconAction), for: .touchUpInside)
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        eyeButton.center = rightPaddingView.center
        rightPaddingView.addSubview(eyeButton)
        
        $0.isSecureTextEntry = true
        $0.rightView = rightPaddingView
        $0.rightViewMode = .always
    }
    
    @objc func iconAction(sender: UIButton) {
        sender.isSelected.toggle()
        pwdTextField.isSecureTextEntry.toggle()
    }
    
    public lazy var loginButton = longCustomBtn(
        backgroundColor: UIColor.dmrBlue!,
        title: "확인",
        titleColor: .white!,
        height: 45
    )
    
    public lazy var foundIDBtn: longCustomBtn = {
        return longCustomBtn(
            backgroundColor: .clear,
            title: "ID 찾기",
            titleColor: .grey400!,
            font: .ptdSemiBoldFont(ofSize: 14),
            width: 100,
            height: 30
        )
    }()
    
    private lazy var verticalLine: UIView = {
        let line = UIView()
        line.backgroundColor = .grey300
        line.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(8)
        }
        return line
    }()
    
    public lazy var foundPWBtn: longCustomBtn = {
        return longCustomBtn(
            backgroundColor: .clear,
            title: "PW 찾기",
            titleColor: .grey400!,
            font: .ptdSemiBoldFont(ofSize: 14),
            width: 100,
            height: 30
        )
    }()
    
    private let foundContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    //MARK: - container
    
    private lazy var loginContainer: UIView = {
        let view = UIView()
        [foundIDBtn,verticalLine,foundPWBtn].forEach {foundContainer.addArrangedSubview($0)}
        
        [
            logoImageView,
            inputTextContainer,
            loginButton,
            foundContainer
        ].forEach {
            view.addSubview($0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 75, height: 75))
        }
        
        inputTextContainer.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(pwdTextField.snp.bottom)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(inputTextContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        
        foundContainer.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        return view
    }()
    
    private lazy var inputTextContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        [
            idView,
            pwdView
        ].forEach {
            view.addSubview($0)
        }
        
        idView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        pwdView.snp.makeConstraints {
            $0.top.equalTo(idView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        return view
    }()
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .white
        addSubview(loginContainer)
        setupConstraints()
    }
    
    private func setupConstraints() {
        loginContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(foundPWBtn.snp.bottom)
        }
    }
}

// MARK: - Helper Methods

private func createImageView(named name: String) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: name)
    imageView.contentMode = .scaleAspectFit
    return imageView
}
