//
//  NotFoundIDView.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

class NotFoundIDView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var errorLogo = UIImageView().then {
        $0.image = UIImage(named: "logo_error")
    }
    
    private lazy var contentLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        let text = "입력된 정보로 가입된 덕메랑 계정이 없습니다.\n확인 후 다시 시도해주세요."
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdRegularFont(ofSize: 16),
            .foregroundColor: UIColor.grey600 ?? .gray,
            .paragraphStyle: paragraphStyle
        ]

        $0.attributedText = NSAttributedString(string: text, attributes: attributes)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let middleContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 24
    }
    
    public lazy var loginBtn = longCustomBtn(title: "홈으로 돌아가기")
    
    private func setupView() {
        middleContainer.addArrangedSubview(errorLogo)
        middleContainer.addArrangedSubview(contentLabel)
        
        [
            middleContainer,
            loginBtn,
        ].forEach {
            addSubview($0)
        }
        
        middleContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        loginBtn.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
