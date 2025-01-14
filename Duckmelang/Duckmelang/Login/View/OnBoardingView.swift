//
//  OnBoardingView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit

class OnBoardingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var subtitle: UILabel = {
        let label = createLabel(
            text: "행복하게 덕질하자",
            font: .aritaMediumFont(ofSize: 14),
            textColor: .bgcSecondary!
        )
        label.textAlignment = .center
        return label
    }()
    
    private lazy var title: UILabel = {
        let label = createLabel(
            text: "덕메랑",
            font: .aritaBoldFont(ofSize: 32),
            textColor: .bgcSecondary!
        )
        label.textAlignment = .center
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        return createImageView(named: "logo_yellow")
    }()
    
    public lazy var kakaoLoginButton: UIButton = {
        let button = createButton(
            title: "카카오톡으로 시작하기",
            titleColor: .black!,
            backgroundColor: .kakaoYellow!,
            iconName: "kakaoLogo"
        )
        
        return button
    }()
    
    //TODO: 구글로 시작하기, 휴대폰번호로 시작하기 버튼 만들기
    
    private lazy var signinLabel: UILabel = {
        let label = createLabel(
            text: "이미 가입하셨나요?",
            font: .ptdRegularFont(ofSize: 13),
            textColor: .grey500!
        )
        label.textAlignment = .center
        return label
    }()
    
    public lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.dmrBlue!, for: .normal)
        button.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 14)
        button.backgroundColor = .white
        button.clipsToBounds = true
        
        return button
    }()
    
    
    //MARK: - Containers
    private lazy var headerContainer: UIView = {
        let view = UIView()
        view.addSubviews(subtitle, title, logoImageView)
        
        subtitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
            
        title.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(75)
        }
        
        return view
    }()
    
    private lazy var loginBtnsContainer: UIView = {
        let view = UIView()
        view.addSubviews(kakaoLoginButton, signinLabel)
        //TODO: 구글로 시작하기, 휴대폰번호로 시작하기 붙이기
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        return view
    }()
    
    private lazy var signinContainer: UIView = {
        let view = UIView()
        view.addSubviews(signinLabel, loginButton)
        
        signinLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
        return view
    }()
    
    // MARK: - Setup Methods
    private func setupView() {
        self.backgroundColor = .white
        addSubviews(
            headerContainer,
            loginBtnsContainer,
            signinContainer
        )
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        headerContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(236)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(165)
        }
        
        loginBtnsContainer.snp.makeConstraints {
            $0.top.equalTo(headerContainer.snp.bottom).offset(165)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(16)
            $0.height.equalTo(145)
        }
        
        signinContainer.snp.makeConstraints {
            $0.top.equalTo(loginBtnsContainer.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(28)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createImageView(named name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        return imageView
    }
    
    private func createLabel(text: String, font: UIFont, textColor: UIColor, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        return label
    }
    
    private func createButton(title: String, titleColor: UIColor, backgroundColor: UIColor, iconName: String? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        // Create StackView for icon and title
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8 // 간격 설정
        stackView.distribution = .equalCentering
        
        // Add Icon if available
        if let iconName = iconName {
            let imageView = createImageView(named: iconName)
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints { $0.size.equalTo(16) } // Icon 크기 설정
            stackView.addArrangedSubview(imageView)
        }
        
        // Add Title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.ptdBoldFont(ofSize: 14)
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        // Add StackView to Button
        button.addSubview(stackView)
        stackView.snp.makeConstraints { $0.center.equalToSuperview() } // StackView 버튼 중앙 배치
        
        return button
    }
    
}

// MARK: - UIView Extension

private extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
