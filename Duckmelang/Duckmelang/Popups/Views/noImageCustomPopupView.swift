//
//  noImageCustomPopupView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/20/25.
//

import UIKit

class noImageCustomPopupView: UIView {
    init(
        title: String,
        subTitle: String,
        subTitleColor: UIColor = .grey600 ?? .gray,
        leftBtnTitle: String = "",
        rightBtnTitle: String = ""
    ) {
        super.init(frame: .zero)
        
        self.title.text = title
        self.subTitle.text = subTitle
        self.subTitle.textColor = subTitleColor
        
        if (leftBtnTitle == "") && (rightBtnTitle == "") {
            self.btnStackView.isHidden = true
        } else if (leftBtnTitle == "") {
            self.leftBtn.isHidden = true
            self.rightBtn.setTitle(rightBtnTitle, for: .normal)
        } else {
            self.leftBtn.setTitle(leftBtnTitle, for: .normal)
            self.rightBtn.setTitle(rightBtnTitle, for: .normal)
        }
        
        self.backgroundColor = .clear
        self.addSubview(self.panel)
        self.addSubview(self.popupView)
        
        [self.textStackView, self.btnStackView]
          .forEach(self.popupView.addSubview(_:))
        [self.title, self.subTitle]
          .forEach(self.textStackView.addArrangedSubview(_:))
        [self.leftBtn, self.rightBtn]
            .forEach(self.btnStackView.addArrangedSubview(_:))
        
        setupView()
        
        self.popupView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(292 + 48)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
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
        $0.spacing = 8
    }
    
    private lazy var title = UILabel().then {
        $0.textColor = .grey800
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .ptdSemiBoldFont(ofSize: 16)
    }
    
    private lazy var subTitle = UILabel().then {
        $0.textColor = .grey600
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .ptdRegularFont(ofSize: 13)
    }
    
    lazy var leftBtn = smallStorkeCustomBtn(width: 140, height: 44)
    lazy var rightBtn = smallFilledCustomBtn(width: 140, height: 44)
    
    private lazy var btnStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    func setupView() {
        self.panel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.textStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.btnStackView.snp.makeConstraints {
            $0.top.equalTo(textStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
