//
//  CompleteResetPasswordView.swift
//  Duckmelang
//
//  Created by 주민영 on 3/23/25.
//

import UIKit

class CompleteResetPasswordView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "logo_yellow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var contentLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        let text = "비밀번호 변경이 완료되었습니다.\n다시 로그인해주세요."
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdRegularFont(ofSize: 16),
            .foregroundColor: UIColor.grey600 ?? .gray,
            .paragraphStyle: paragraphStyle
        ]

        $0.attributedText = NSAttributedString(string: text, attributes: attributes)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let middleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 24
    }
    
    public lazy var loginBtn = longCustomBtn(title: "로그인")
    
    private func setupView() {
        middleStackView.addArrangedSubview(logo)
        middleStackView.addArrangedSubview(contentLabel)
        
        [
            middleStackView,
            loginBtn
        ].forEach {
            addSubview($0)
        }
        
        logo.snp.makeConstraints {
            $0.width.height.equalTo(74)
        }
        
        middleStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        loginBtn.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.centerX.equalToSuperview()
        }
    }
}
