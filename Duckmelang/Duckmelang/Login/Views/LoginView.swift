//  LoginView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SnapKit
import Then

class LoginView: UIView {
    
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
        return createInputView(
            placeholder: "아이디",
            textField: emailTextField
        )
    }()
    
    private lazy var emailTextField: UITextField = {
        return createTextField()
    }()
    
    private lazy var pwdView: UIView = {
        return createInputView(
            placeholder: "비밀번호",
            textField: pwdTextField
        )
    }()
    
    private lazy var pwdTextField: UITextField = {
        return createTextField(isSecure: true)
    }()
    
    public lazy var loginButton: UIButton = {
        return createButton(
            title: "확인",
            titleColor: UIColor.white!,
            backgroundColor: UIColor.grey400!
        )
    }()
    
    public lazy var foundIDBtn: UIButton = {
        return createButton(
            title: "ID찾기",
            titleColor: .grey400!,
            backgroundColor: .clear
        )
    }()
    
    public lazy var foundPWBtn: UIButton = {
        return createButton(
            title: "PW찾기",
            titleColor: .grey400!,
            backgroundColor: .clear
        )
    }()
    
    private lazy var verticalLine: UIView = {
        let line = UIView()
        line.backgroundColor = .grey300 // 선 색상 설정
        line.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(16)
        }
        return line
    }()
    
    
    
    //MARK: - container
    private lazy var loginContainer: UIView = {
        let view = UIView()
        view
            .addSubviews(
                logoImageView,
                inputTextContainer,
                loginButton,
                foundBtnContainer
            )
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 75, height: 75)) // 로고 크기
        }
        
        inputTextContainer.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(40)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwdView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        foundBtnContainer.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        return view
    }()
    
    private lazy var inputTextContainer: UIView = {
        let view = UIView()
        view.addSubviews(idView, pwdView)
        
        idView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }

        pwdView.snp.makeConstraints {
            $0.top.equalTo(idView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        return view
    }()
    
    private lazy var foundBtnContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [foundIDBtn, verticalLine, foundPWBtn])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12 // 버튼과 선 사이 간격 조정

        return stackView
    }()
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .white
        addSubviews(loginContainer)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        loginContainer.snp.makeConstraints{
            $0.top.equalToSuperview().inset(116)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(foundBtnContainer.snp.bottom)
        }
    }
}

// MARK: - UIView Extension

private extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

// MARK: - Helper Methods

private func createImageView(named name: String) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: name)
    imageView.contentMode = .scaleAspectFit
    return imageView
}

private func createTextField(isSecure: Bool = false) -> UITextField {
    let textField = UITextField()
    textField.layer.cornerRadius = 5
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.grey400!.cgColor
    textField.font = UIFont.ptdRegularFont(ofSize: 15)
    textField.textColor = .grey600
    textField.isSecureTextEntry = isSecure
    
    // 왼쪽 여백 추가
    let leftPaddingView = UIView(
        frame: CGRect(x: 0, y: 0, width: 16, height: 0)
    )
    textField.leftView = leftPaddingView
    textField.leftViewMode = .always
    
    return textField
}

private func createInputView(placeholder: String, textField: UITextField) -> UIView {
    let view = UIView()
    view.backgroundColor = .white
    textField.placeholder = placeholder
    
    view.addSubviews(textField)
    
    textField.snp.makeConstraints {
        $0.top.equalToSuperview()
        $0.bottom.equalToSuperview()
        $0.left.right.equalToSuperview().inset(16) // 좌우 여백
    }
    
    return view
}

private func createButton(title: String, titleColor: UIColor, backgroundColor: UIColor) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.backgroundColor = backgroundColor
    button.layer.cornerRadius = 20
    button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 16)
    return button
}
