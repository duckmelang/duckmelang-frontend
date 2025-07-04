//
//  FoundIDView.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

class FoundIDView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let idLabel = UILabel().then {
        $0.text = "Deokmerang1234" // 임시 텍스트
        $0.font = .ptdSemiBoldFont(ofSize: 17)
        $0.textColor = .grey800
        $0.numberOfLines = 0
        $0.textAlignment = .center

        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    
    public let phoneNumLabel = UILabel().then {
        $0.text = "(전화번호)로 저장된 아이디에요"
        $0.font = .ptdRegularFont(ofSize: 16)
        $0.textColor = .grey700
        $0.numberOfLines = 0
    }
    
    private let middleContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 24
    }
    
    public lazy var loginBtn = longCustomBtn(title: "로그인")
    
    private func setupView() {
        middleContainer.addArrangedSubview(idLabel)
        middleContainer.addArrangedSubview(phoneNumLabel)
        
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
        
        idLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
