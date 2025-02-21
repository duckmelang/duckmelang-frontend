//
//  OnBoardingView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import Then

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
    
    //FIXME: - 개발 종료 후 gohome 지우기 1
    public lazy var goHome: UIButton = {
        let button = createButton(
            title: " 홈화면 연결통로",
            titleColor: .black!,
            backgroundColor: .mainColor!,
            iconName: nil,
            borderColor: .grey300!
        )
        return button
    }()
    
    public lazy var kakaoLoginButton: UIButton = {
        let button = createButton(
            title: "카카오톡으로 시작하기",
            titleColor: .black!,
            backgroundColor: .kakaoYellow!,
            iconName: "kakaoLogo",
            borderColor: .clear
        )
        
        return button
    }()
    
    public lazy var googleLoginButton: UIButton = {
        let button = createButton(
            title: "구글로 시작하기",
            titleColor: .black!,
            backgroundColor: .white!,
            iconName: "googleLogo",
            borderColor: .grey300!
        )
        
        return button
    }()
    
    public lazy var phoneLoginButton: UIButton = {
        let button = createButton(
            title: "휴대폰 번호로 시작하기",
            titleColor: .grey0!,
            backgroundColor: .dmrBlue!,
            iconName: nil,
            borderColor: .clear
        )
        
        return button
    }()
    
    private lazy var signinLabel: UILabel = {
        let label = createLabel(
            text: "이미 가입하셨나요?",
            font: .ptdRegularFont(ofSize: 13),
            textColor: .grey500!
        )
        label.textAlignment = .center
        return label
    }()
    
    public lazy var loginButton = UIButton().then {
        let title = "로그인"
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue, // 밑줄 추가
            .foregroundColor: UIColor.dmrBlue!, // 텍스트 색상
            .font: UIFont.ptdSemiBoldFont(ofSize: 14) // 폰트 설정
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        $0.setAttributedTitle(attributedTitle, for: .normal)
        
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    
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
            $0.width.equalTo(75)
            $0.height.equalTo(75)
        }
        
        return view
    }()
    
    private lazy var loginBtnsContainer: UIView = {
        let view = UIView()
        view.addSubviews(kakaoLoginButton, googleLoginButton, phoneLoginButton)
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        phoneLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(12)
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
            //FIXME: - 개발 종료 후 gohome 지우기 2
//            goHome,
            loginBtnsContainer,
            signinContainer
        )
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        headerContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(236)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(16)
            $0.bottom.equalTo(logoImageView.snp.bottom)
        }
        
//        //FIXME: - 개발 종료 후 gohome 지우기 3
//        goHome.snp.makeConstraints{
//            $0.top.equalTo(headerContainer.snp.bottom).offset(15)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(200)
//            $0.height.equalTo(40)
//        }
        
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
    
    private func createButton(title: String, titleColor: UIColor, backgroundColor: UIColor, iconName: String? = nil, borderColor: UIColor = .clear) -> UIButton {
            let button = UIButton()
            button.backgroundColor = backgroundColor
            button.layer.cornerRadius = 20
            button.clipsToBounds = true

            if borderColor != .clear {
                button.layer.borderColor = borderColor.cgColor
                button.layer.borderWidth = 1
            }

            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 8
            stackView.distribution = .fill
            stackView.isUserInteractionEnabled = false

            if let iconName = iconName {
                let imageView = createImageView(named: iconName)
                imageView.contentMode = .scaleAspectFit
                imageView.snp.makeConstraints { $0.size.equalTo(16) }
                stackView.addArrangedSubview(imageView)
            }

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.ptdSemiBoldFont(ofSize: 14)
            titleLabel.textColor = titleColor
            titleLabel.textAlignment = .center
            stackView.addArrangedSubview(titleLabel)

            button.addSubview(stackView)
            stackView.snp.makeConstraints { $0.center.equalToSuperview() }

            return button
        }
    
}

// MARK: - UIView Extension

private extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
