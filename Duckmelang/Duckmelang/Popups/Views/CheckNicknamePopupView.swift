//
//  CheckNicknamePopupView.swift
//  Duckmelang
//
//  Created by 주민영 on 4/2/25.
//

import UIKit

class CheckNicknamePopupView: UIView {
    init(
        isAvailable: Bool
    ) {
        super.init(frame: .zero)
        
        if (isAvailable) {
            self.subTitle.text = "사용 가능한 닉네임입니다."
            self.subTitle.textColor = .grey800
        } else {
            self.subTitle.text = "중복된 닉네임입니다."
            self.subTitle.textColor = .errorPrimary
        }
        
        self.backgroundColor = .clear
        self.addSubview(self.panel)
        self.addSubview(self.popupView)
        
        [self.textStackView, self.btn]
          .forEach(self.popupView.addSubview(_:))
        [self.title, self.subTitle]
          .forEach(self.textStackView.addArrangedSubview(_:))
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var panel = UIButton().then {
        $0.backgroundColor = UIColor.grey800?.withAlphaComponent(0.6)
    }
    
    private lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 7
        $0.clipsToBounds = true
    }
    
    private lazy var textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var title = UILabel().then {
        $0.textColor = .grey900
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .ptdSemiBoldFont(ofSize: 18)
        $0.text = "닉네임 확인"
    }
    
    private lazy var subTitle = UILabel().then {
        $0.textColor = .grey800
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .ptdMediumFont(ofSize: 13)
    }
    
    lazy var btn = smallFilledCustomBtn(title: "확인")
    
    func setupView() {
        self.popupView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(145)
        }
        
        self.panel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.textStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        self.btn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
